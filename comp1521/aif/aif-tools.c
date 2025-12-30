#include "aif.h"
#include <stdint.h>
#include <stdio.h>
#include <sys/stat.h>
#include <string.h>
#include <stdlib.h>


static uint16_t computeChecksum(FILE *fp);
static void printInfo(const char *filename, struct stat st, int magic_ok, uint16_t checksum, uint16_t comChecksum,
    uint8_t pixel_fmt, const  char *compName, uint32_t width,uint32_t height);
// Takes in a RGB color and brightens it by the given percentage amount
uint32_t brighten_rgb(uint32_t color, int amount);

static uint32_t getPixel_offset(unsigned char hdr[20]);
static uint32_t getWidth(unsigned char hdr[20]);
static uint32_t getHeight(unsigned char hdr[20]);
static void rewritetChecksum(const char *out_file, unsigned char hdr[AIF_HEADER_SIZE]);
static int getRowLenComp(FILE *in);
static int magicOk(unsigned char hdr[20]);
static uint16_t getChecksum(unsigned char hdr[20]);
static void s4HandleNotRepeat(FILE *in, unsigned char rowBuf[], int filled, int diffByteNum);
static void s4HandleRepeat(FILE *in, unsigned char rowBuf[], int filled, int flag);
static int read_le16(FILE *f, uint16_t *out);
static int compressRow(const unsigned char *rowBuf, int width,
                       int bpp, unsigned char *rleBuf);
static void copy_file(FILE *src, FILE *dst);


void stage1_info(int n_files, const char **files) {

    for (int i = 0; i < n_files; i++) {
        const char *filename = files[i];

       

        //1. get file size (stat)
        struct stat st;
        if (stat(filename, &st) != 0) {
            fprintf(stderr, "Cannot stat %s\n", filename);
            continue;
        }
        

        // 2 open file
        FILE *fp = fopen(filename, "rb");
        if (fp == NULL) {
            fprintf(stderr, "Cannot open %s\n", filename);
            continue;
        }

        // 3. read header
        unsigned char hdr[20];
        if (fread(hdr, 1, 20, fp) < 20) {
            fprintf(stderr, "Header too short: %s\n", filename);
            fclose(fp);
            continue;
        }

        uint16_t comChecksum = computeChecksum(fp);        
        fclose(fp);


        int magic_ok = 0;
        if (hdr[0] == 0x41 && hdr[1] == 0x49 && hdr[2] == 0x46 && hdr[3] == 0x00) {
            magic_ok = 1;
        };
        // 4.  checksum (LE 2 bytes) 
        uint16_t checksum = getChecksum(hdr);
        


        // 5. Pixel format 
        uint8_t fmt = hdr[AIF_PXL_FMT_OFFSET];
        // const char *pixForName = aif_pixel_format_name(fmt);


        // 6. Compression 
        uint8_t comp = hdr[AIF_COMPRESSION_OFFSET];
        const char *compName = aif_compression_name(comp);
        

        // 7. Width & Height (LE 4 bytes each)
        uint32_t width = getWidth(hdr);

        uint32_t height = getHeight(hdr);
        printInfo(filename, st, magic_ok, checksum, comChecksum, fmt, compName, width, height);

    }
}




void stage2_brighten(int amount, const char *in_file, const char *out_file) {
    FILE *in = fopen(in_file, "rb");
    if (!in) {
        perror("open input");
        return;
    }    

    
    // 2. read header
    unsigned char hdr[AIF_HEADER_SIZE];
    if (fread(hdr, 1, AIF_HEADER_SIZE, in) < AIF_HEADER_SIZE) {
        fprintf(stderr, "Invalid header.\n");
        fclose(in);
        return;
    }
    //
    // 3. 
    //
    uint8_t fmt  = hdr[AIF_PXL_FMT_OFFSET];
    uint8_t comp = hdr[AIF_COMPRESSION_OFFSET];


    // decompress if Compressed
    if (comp != AIF_COMPRESSION_NONE) {
        fprintf(stderr, "Unexpected AIF_COMPRESSION\n");
        fclose(in);        
    }


    uint32_t width = getWidth(hdr);

    uint32_t height = getHeight(hdr);

    uint32_t pixel_offset = getPixel_offset(hdr);
    uint32_t num_pixels = width * height;
    
    // 4. open out file write header
    FILE *out = fopen(out_file, "wb");
    if (!out) {
        perror("open output");
        fclose(in);
        return;
    }

    hdr[AIF_CHECKSUM_OFFSET] = 0;
    hdr[AIF_CHECKSUM_OFFSET+1] = 0;
    fwrite(hdr, 1, AIF_HEADER_SIZE, out);

    
    // 5. seek to pixel
    fseek(in, pixel_offset, SEEK_SET);

    
    // 6. write pixel
    if (fmt == AIF_FMT_RGB8) {
        // RGB：3 bytes per pixel
        for (uint32_t i = 0; i < num_pixels; i++) {
            int r = fgetc(in);
            int g = fgetc(in);
            int b = fgetc(in);

            if (r == EOF || g == EOF || b == EOF) {
                fprintf(stderr, "Unexpected EOF\n");
                fclose(in);
                fclose(out);
                return;
            }
            uint32_t old_pixel = r | (g << 8) | (b << 16);
            uint32_t new_pixel = brighten_rgb(old_pixel, amount);

            fputc(new_pixel & 0xFF, out);
            fputc((new_pixel >> 8) & 0xFF, out);
            fputc((new_pixel >> 16) & 0xFF, out);
        }

    } else if (fmt == AIF_FMT_GRAY8) {
        // Gray：1 byte per pixel
        for (uint32_t i = 0; i < num_pixels; i++) {
            int gray = fgetc(in);
            if (gray == EOF) {
                fprintf(stderr, "Unexpected EOF\n");
                fclose(in);
                fclose(out);
                return;
            }

            int new_gray = gray * (100 + amount) / 100;

            if (new_gray < 0) new_gray = 0;
            if (new_gray > 255) new_gray = 255;

            fputc(new_gray, out);
        }

    } else {
        fprintf(stderr, "Unknown pixel format\n");
        fclose(in);
        fclose(out);
        return;
    }

    fclose(in);

    //
    // 7. clean up rewrite checksum
    //
    fflush(out);
    fclose(out);

    rewritetChecksum(out_file, hdr);

}



void stage3_convert_color(const char *color, const char *in_file, const char *out_file) {

    FILE *in = fopen(in_file, "rb");
    if (!in) { perror("open input"); return; }

    unsigned char hdr[AIF_HEADER_SIZE];
    if (fread(hdr, 1, AIF_HEADER_SIZE, in) < AIF_HEADER_SIZE) {
        fprintf(stderr, "Invalid header\n");
        fclose(in);
        return;
    }

    uint8_t fmt = hdr[AIF_PXL_FMT_OFFSET];
    uint8_t comp = hdr[AIF_COMPRESSION_OFFSET];

    if (comp != AIF_COMPRESSION_NONE) {
        fprintf(stderr, "Compressed AIF not supported in stage3.\n");
        fclose(in);
        return;
    }

    uint32_t width = getWidth(hdr);
    uint32_t height = getHeight(hdr);

    uint32_t pixel_offset = getPixel_offset(hdr);

    FILE *out = fopen(out_file, "wb");
    if (!out) { perror("open out"); fclose(in); return; }

    // set new pixel format
    uint8_t target_fmt;

    if (strcmp(color, "gray8") == 0) {
        target_fmt = AIF_FMT_GRAY8;
    } else if (strcmp(color, "rgb8") == 0) {
        target_fmt = AIF_FMT_RGB8;
    } else {
        fprintf(stderr, "Unknown color type\n");
        fclose(in);
        fclose(out);
        return;
    }

    hdr[AIF_PXL_FMT_OFFSET] = target_fmt;

    // checksum write 0
    hdr[AIF_CHECKSUM_OFFSET] = 0;
    hdr[AIF_CHECKSUM_OFFSET+1] = 0;
    // out write hdr
    fwrite(hdr, 1, AIF_HEADER_SIZE, out);

    fseek(in, pixel_offset, SEEK_SET);
    uint32_t pixels = width * height;

    //   RGB → RGB
    if (fmt == AIF_FMT_RGB8 && target_fmt == AIF_FMT_RGB8) {
        for (uint32_t i = 0; i < pixels; i++) {
            int r = fgetc(in);
            int g = fgetc(in);
            int b = fgetc(in);

            if (r == EOF || g == EOF || b == EOF) {
                fprintf(stderr, "Unexpected EOF\n");
                fclose(in); fclose(out);
                return;
            }

            fputc(r, out);
            fputc(g, out);
            fputc(b, out);
        }
    }

    //   GRAY8 → GRAY8
    else if (fmt == AIF_FMT_GRAY8 && target_fmt == AIF_FMT_GRAY8) {
        for (uint32_t i = 0; i < pixels; i++) {
            int gray = fgetc(in);
            if (gray == EOF) {
                fprintf(stderr, "Unexpected EOF\n");
                fclose(in); fclose(out);
                return;
            }
            fputc(gray, out);
        }
    }


    //   RGB → GRAY8
    else if (fmt == AIF_FMT_RGB8 && target_fmt == AIF_FMT_GRAY8) {

        for (uint32_t i = 0; i < pixels; i++) {

            int r = fgetc(in);
            int g = fgetc(in);
            int b = fgetc(in);

            if (r == EOF || g == EOF || b == EOF) {
                fprintf(stderr, "Unexpected EOF\n");
                fclose(in);
                fclose(out);
                return;
            }

            int gray = (r * 299 + g * 587 + b * 114) / 1000;
            fputc(gray, out);
        }
    }

    //   GRAY8 → RGB
    else if (fmt == AIF_FMT_GRAY8 && target_fmt == AIF_FMT_RGB8) {

        for (uint32_t i = 0; i < pixels; i++) {

            int gray = fgetc(in);
            if (gray == EOF) {
                fprintf(stderr, "Unexpected EOF\n");
                fclose(in);
                fclose(out);
                return;
            }

            fputc(gray, out);
            fputc(gray, out);
            fputc(gray, out);
        }
    }

    else {
        fprintf(stderr, "Unsupported conversion\n");
        fclose(in);
        fclose(out);
        return;
    }

    fclose(in);
    //
    // 7. clean up rewrite checksum
    //
    fflush(out);
    fclose(out);
    rewritetChecksum(out_file, hdr);
}


void stage4_decompress(const char *in_file, const char *out_file) {
    // 1. open in file and read header
    FILE *in = fopen(in_file, "rb");
    if (in == NULL) {
        perror("open input");
        return;
    }

    unsigned char hdr[AIF_HEADER_SIZE];
    if (fread(hdr, 1, AIF_HEADER_SIZE, in) < AIF_HEADER_SIZE) {
        fprintf(stderr, "Invalid header\n");
        fclose(in);
        return;
    }

    uint8_t fmt       = hdr[AIF_PXL_FMT_OFFSET];
    uint8_t comp      = hdr[AIF_COMPRESSION_OFFSET];
    int magic_ok      = magicOk(hdr);
    uint32_t width    = getWidth(hdr);
    uint32_t height   = getHeight(hdr);
    uint16_t checksum = getChecksum(hdr);
    uint32_t pixel_offset = getPixel_offset(hdr);

    // 2. check header
    if (!magic_ok) {
        fprintf(stderr, "MAGIC INVALID\n");
        fclose(in);
        return;
    }
    if (comp != AIF_COMPRESSION_RLE) {
        fprintf(stderr, "ONLY ACCEPT RLE COMPRESSION FILE\n");
        fclose(in);
        return;
    }
    if (width == 0 || height == 0) {
        fprintf(stderr, "Width/Height must be > 0\n");
        fclose(in);
        return;
    }

    // check checksum
    long after_header_pos = ftell(in);
    if (after_header_pos == -1) {
        perror("ftell");
        fclose(in);
        return;
    }

    if (fseek(in, 0, SEEK_SET) != 0) {
        perror("fseek");
        fclose(in);
        return;
    }

    uint16_t actual_checksum = computeChecksum(in);
    if (checksum != actual_checksum) {
        fprintf(stderr, "checksum incorrect\n");
        fclose(in);
        return;
    }

    // seek to start
    if (fseek(in, (long)pixel_offset, SEEK_SET) != 0) {
        perror("fseek pixel_offset");
        fclose(in);
        return;
    }

    // 3. open out file，write header
    FILE *out = fopen(out_file, "wb");
    if (out == NULL) {
        perror("open output");
        fclose(in);
        return;
    }

    hdr[AIF_CHECKSUM_OFFSET]     = 0;
    hdr[AIF_CHECKSUM_OFFSET + 1] = 0;
    hdr[AIF_COMPRESSION_OFFSET] = AIF_COMPRESSION_NONE;  

    if (fwrite(hdr, 1, AIF_HEADER_SIZE, out) < AIF_HEADER_SIZE) {
        fprintf(stderr, "write header failed\n");
        fclose(in);
        fclose(out);
        return;
    }

    if (fseek(out, (long)pixel_offset, SEEK_SET) != 0) {
        perror("fseek out pixel_offset");
        fclose(in);
        fclose(out);
        return;
    }

    // 4. bytes_per_pixel
    int bytes_per_pixel;
    if (fmt == AIF_FMT_RGB8) {
        bytes_per_pixel = 3;
    } else if (fmt == AIF_FMT_GRAY8) {
        bytes_per_pixel = 1;
    } else {
        fprintf(stderr, "pixel format invalid\n");
        fclose(in);
        fclose(out);
        return;
    }

    // pixel byte num after decompress
    uint32_t row_pixels_bytes = width * (uint32_t)bytes_per_pixel;

    // 缓冲
    unsigned char *rowBuf = malloc(row_pixels_bytes);
    if (rowBuf == NULL) {
        fprintf(stderr, "malloc rowBuf failed\n");
        fclose(in);
        fclose(out);
        return;
    }

    // 5. decode RLE row by row
    for (uint32_t r = 0; r < height; r++) {
        // 5.1 read NNNN
        uint16_t comp_row_len;
        if (!read_le16(in, &comp_row_len)) {
            fprintf(stderr, "Unexpected EOF while reading row length\n");
            free(rowBuf);
            fclose(in);
            fclose(out);
            return;
        }

        uint32_t filled = 0;      // bytes count decoded to rowBuf
        uint32_t consumed = 0;    // 已经消费的压缩字节数(不含 NNNN 自身)

        while (consumed < comp_row_len) {
            int flag = fgetc(in);
            if (flag == EOF) {
                fprintf(stderr, "Unexpected EOF while reading flag\n");
                free(rowBuf);
                fclose(in);
                fclose(out);
                return;
            }
            consumed++;

            if (flag == 0) {
                // not repeat: [00] [YY] [pixel0]..[pixelYY-1]
                int count = fgetc(in);
                if (count == EOF) {
                    fprintf(stderr, "Unexpected EOF while reading non-repeat count\n");
                    free(rowBuf);
                    fclose(in);
                    fclose(out);
                    return;
                }
                consumed++;

                // read count pixels, each bytes_per_pixel byte
                for (int i = 0; i < count; i++) {
                    for (int b = 0; b < bytes_per_pixel; b++) {
                        int byte = fgetc(in);
                        if (byte == EOF) {
                            fprintf(stderr, "Unexpected EOF in non-repeat pixels\n");
                            free(rowBuf);
                            fclose(in);
                            fclose(out);
                            return;
                        }
                        consumed++;
                        if (filled >= row_pixels_bytes) {
                            // check out bound
                            fprintf(stderr, "Row overflow while decoding (non-repeat)\n");
                            free(rowBuf);
                            fclose(in);
                            fclose(out);
                            return;
                        }
                        rowBuf[filled++] = (unsigned char)byte;
                    }
                }

            } else {
                //repeat  [XX] [pixel]  → pixel repeat XX times
                int count = flag;  // pixel num

                // read 1 pixel
                unsigned char pixel[4];  // 
                for (int b = 0; b < bytes_per_pixel; b++) {
                    int byte = fgetc(in);
                    if (byte == EOF) {
                        fprintf(stderr, "Unexpected EOF in repeat pixel\n");
                        free(rowBuf);
                        fclose(in);
                        fclose(out);
                        return;
                    }
                    consumed++;
                    pixel[b] = (unsigned char)byte;
                }

                // write count pixel
                for (int i = 0; i < count; i++) {
                    for (int b = 0; b < bytes_per_pixel; b++) {
                        if (filled >= row_pixels_bytes) {
                            fprintf(stderr, "Row overflow while decoding (repeat)\n");
                            free(rowBuf);
                            fclose(in);
                            fclose(out);
                            return;
                        }
                        rowBuf[filled++] = pixel[b];
                    }
                }
            }
        }

        // check length
        if (filled != row_pixels_bytes) {
            //
            if (filled < row_pixels_bytes) {
                // fill 0
                for (uint32_t i = filled; i < row_pixels_bytes; i++) {
                    rowBuf[i] = 0;
                }
            }
        }

        // 5.2 write pixel
        if (fwrite(rowBuf, 1, row_pixels_bytes, out) < row_pixels_bytes) {
            fprintf(stderr, "write row failed\n");
            free(rowBuf);
            fclose(in);
            fclose(out);
            return;
        }
    }
    free(rowBuf);
    fclose(in);
    fflush(out);
    fclose(out);
    rewritetChecksum(out_file, hdr);
}



void stage5_compress(const char *in_file, const char *out_file)
{
    FILE *in = fopen(in_file, "rb");
    if (!in) { perror("open input"); return; }

    unsigned char hdr[AIF_HEADER_SIZE];
    if (fread(hdr, 1, AIF_HEADER_SIZE, in) < AIF_HEADER_SIZE) {
        fprintf(stderr, "Invalid header\n");
        fclose(in);
        return;
    }

    if (!magicOk(hdr)) {
        fprintf(stderr, "MAGIC INVALID\n");
        fclose(in);
        return;
    }

    uint8_t fmt       = hdr[AIF_PXL_FMT_OFFSET];

    uint32_t width    = getWidth(hdr);
    uint32_t height   = getHeight(hdr);
    uint32_t pixel_offset = getPixel_offset(hdr);

    if (width == 0 || height == 0) {
        fprintf(stderr, "Width/Height must > 0\n");
        fclose(in);
        return;
    }

    int bpp;
    if (fmt == AIF_FMT_RGB8)      bpp = 3;
    else if (fmt == AIF_FMT_GRAY8) bpp = 1;
    else {
        fprintf(stderr, "Unsupported format\n");
        fclose(in);
        return;
    }

    FILE *out = fopen(out_file, "wb");
    if (!out) { perror("open output"); fclose(in); return; }

    // header, checksum=0, compression=RLE(00 00)
    hdr[AIF_COMPRESSION_OFFSET]     = AIF_COMPRESSION_RLE;
    hdr[AIF_CHECKSUM_OFFSET]        = 0;
    hdr[AIF_CHECKSUM_OFFSET + 1]    = 0;

    fwrite(hdr, 1, AIF_HEADER_SIZE, out);

    fseek(in, pixel_offset, SEEK_SET);
    fseek(out, pixel_offset, SEEK_SET);

    int rowBytes = width * bpp;
    unsigned char *rowBuf = malloc(rowBytes);

    for (int r = 0; r < height; r++) {
        if (fread(rowBuf, 1, rowBytes, in) != rowBytes) {
            fprintf(stderr, "Unexpected EOF\n");
            free(rowBuf);
            fclose(in);
            fclose(out);
            return;
        }

        unsigned char rleBuf[10000];
        int rleSize = compressRow(rowBuf, width, bpp, rleBuf);

        // NNNN
        fputc(rleSize & 0xFF, out);
        fputc((rleSize >> 8) & 0xFF, out);

        fwrite(rleBuf, 1, rleSize, out);
    }

    free(rowBuf);

    // rewrite checksum
    fflush(out);
    uint16_t chksum = computeChecksum(out);

    fseek(out, AIF_CHECKSUM_OFFSET, SEEK_SET);
    fputc(chksum & 0xFF, out);
    fputc((chksum >> 8) & 0xFF, out);

    fclose(in);
    fflush(out);
    fclose(out);

    rewritetChecksum(out_file, hdr);
}



// compare 2 pixel return 1 if equals else return 0
static int pixelEqual(unsigned char *p1, unsigned char *p2, int bytePerPixel) {
    for (int i = 0; i < bytePerPixel; i++) {
        if (p1[i] != p2[i]) {
            return 0;   // unequal
        }
    }
    return 1;   // equal
}


// check magic is valid or not, return 1 if valid else 0
static int magicOk(unsigned char hdr[20]) {
    if (hdr[0] == 0x41 && hdr[1] == 0x49 && hdr[2] == 0x46 && hdr[3] == 0x00) {
        return 1;
    };    
    return 0;
}

// retuen checksum
static uint16_t getChecksum(unsigned char hdr[20]) {
    uint16_t checksum = hdr[AIF_CHECKSUM_OFFSET] << 8 |
                        (hdr[AIF_CHECKSUM_OFFSET + 1] );    
    return checksum;                    
}

// return width
static uint32_t getWidth(unsigned char hdr[20]) {
    uint32_t width =
            hdr[AIF_WIDTH_OFFSET] |
            (hdr[AIF_WIDTH_OFFSET+1] << 8) |
            (hdr[AIF_WIDTH_OFFSET+2] << 16) |
            (hdr[AIF_WIDTH_OFFSET+3] << 24);  
    return width;  
}


// returh height
static uint32_t getHeight(unsigned char hdr[20]) {
    uint32_t height =
            hdr[AIF_HEIGHT_OFFSET] |
            (hdr[AIF_HEIGHT_OFFSET+1] << 8) |
            (hdr[AIF_HEIGHT_OFFSET+2] << 16) |
            (hdr[AIF_HEIGHT_OFFSET+3] << 24);
    return height;  
}


// return pixel_offset
static uint32_t getPixel_offset(unsigned char hdr[20]) {
    uint32_t pixel_offset =
        hdr[AIF_PXL_OFFSET_OFFSET] |
        (hdr[AIF_PXL_OFFSET_OFFSET+1] << 8) |
        (hdr[AIF_PXL_OFFSET_OFFSET+2] << 16) |
        (hdr[AIF_PXL_OFFSET_OFFSET+3] << 24);
    return pixel_offset;  
}


static int getRowLenComp(FILE *in) {
    int lo = fgetc(in);
    int hi = fgetc(in);
    int row_len = lo | (hi << 8);
    return row_len;
}

// recalculate checksum and write to outfile
static void rewritetChecksum(const char *out_file, unsigned char hdr[AIF_HEADER_SIZE]) {

    //
    // 8. 重新以读模式打开输出文件计算 checksum
    //
    FILE *out = fopen(out_file, "rb");
    if (!out) { perror("reopen for checksum"); return; }

    uint16_t checksum = computeChecksum(out);
    fclose(out);

    //
    // 9. 再次以读写模式打开，更新 header 中 checksum
    //
    out = fopen(out_file, "r+b");
    if (!out) { perror("reopen to write checksum"); return; }

    hdr[AIF_CHECKSUM_OFFSET] = (checksum) >> 8 & 0xFF;
    hdr[AIF_CHECKSUM_OFFSET+1] = (checksum) & 0xFF;

    fseek(out, 0, SEEK_SET);
    fwrite(hdr, 1, AIF_HEADER_SIZE, out);
    fclose(out); 
}


static void s4HandleNotRepeat(FILE *in, unsigned char rowBuf[], int filled, int diffByteNum){
    for (int i = 0; i < diffByteNum; i++) {
        unsigned char byte = fgetc(in);
        rowBuf[filled + i] = byte;
    }
    
}

static void s4HandleRepeat(FILE *in, unsigned char rowBuf[], int filled, int flag){
    unsigned char byte = fgetc(in);
    for (int i = 0; i < flag; i++) {
        
        rowBuf[filled + i] = byte;
    }
    
    
}



// calculate real checksum
static uint16_t computeChecksum(FILE *fp) {
    int sum1 = 0;
    int sum2 = 0;
    long pos = 0;

    fseek(fp, 0, SEEK_SET);  // 

    int byte;
    while ((byte = fgetc(fp)) != EOF) {
        // set checksum to 0
        if (pos == AIF_CHECKSUM_OFFSET || pos == AIF_CHECKSUM_OFFSET + 1) {
            byte = 0;
        }

        sum1 = (sum1 + byte) % 256;
        sum2 = (sum2 + sum1) % 256;

        pos++;
    }

    return (uint16_t)(sum2 | (sum1 << 8));
}

// print file info
static void printInfo(const char *filename, struct stat st, int magic_ok, uint16_t checksum, uint16_t comChecksum,
     uint8_t pixel_fmt, const  char *compName, uint32_t width,uint32_t height) {
    printf("<%s>:\n", filename);


    printf("File-size: %lld bytes\n", (long long)st.st_size);
    // check magic number
    if (!magic_ok) {
        printf("Invalid header magic.\n");
    }    
    // check checksum
    if (checksum == comChecksum) {
        printf("Checksum: %02x %02x\n",
                checksum & 0xFF,        // low byte
                (checksum >> 8) & 0xFF  // high byte
        );
    } else {
        printf("Checksum: %02x %02x INVALID, calculated %02x %02x\n",
                checksum & 0xFF,        // low byte
                (checksum >> 8) & 0xFF,  // high byte
                comChecksum & 0xFF,
                (comChecksum >> 8) & 0xFF 
        );       
    }

    // check pixel format
    if (pixel_fmt == AIF_FMT_RGB8 || pixel_fmt == AIF_FMT_GRAY8) {
        printf("Pixel format: %s\n", aif_pixel_format_name(pixel_fmt));
    } else {
        printf("Pixel format: Invalid\n");
    }

    printf("Compression: %s\n", compName);

    // check width and height
    if (width > 0) {
        printf("Width: %u px\n", width);
    } else {
        printf("Width: %u px INVALID\n", width);
    }
    
    if (height > 0) {
        printf("Height: %u px\n", height);
    } else {
        printf("Height: %u px INVALID\n", height);
    }   
}

// read 16-bit NNNN 
static int read_le16(FILE *f, uint16_t *out) {
    int b0 = fgetc(f);
    int b1 = fgetc(f);
    if (b0 == EOF || b1 == EOF) {
        return 0;
    }
    *out = (uint16_t)(b0 | (b1 << 8));
    return 1;
}

// get pixel
static void getPixel(
    unsigned char *dest,       // output
    const unsigned char *row,  // row
    int x,                     // x'th pixel
    int bytePerPixel           // 1 or 3
) {
    memcpy(dest, &row[x * bytePerPixel], bytePerPixel);
}



static int compressRow(const unsigned char *rowBuf, int width,
                       int bpp, unsigned char *rleBuf)
{
    int rleSize = 0;

    unsigned char prev_pixel[3];
    unsigned char curr_pixel[3];

    unsigned char nonrep_buf[255 * 3];
    int nonrep_count = 0;

    memcpy(prev_pixel, rowBuf, bpp);
    int repeat = 1;

    for (int x = 1; x < width; x++) {

        memcpy(curr_pixel, &rowBuf[x * bpp], bpp);

        int equal = 1;
        for (int i = 0; i < bpp; i++)
            if (curr_pixel[i] != prev_pixel[i])
                equal = 0;

        if (equal) {
            if (nonrep_count > 0) {
                rleBuf[rleSize++] = 0;
                rleBuf[rleSize++] = nonrep_count;
                memcpy(rleBuf + rleSize, nonrep_buf,
                       nonrep_count * bpp);
                rleSize += nonrep_count * bpp;
                nonrep_count = 0;
            }

            repeat++;
            if (repeat == 256) {
                rleBuf[rleSize++] = 255;
                memcpy(rleBuf + rleSize, prev_pixel, bpp);
                rleSize += bpp;
                repeat = 1;
            }
        }
        else {
            if (repeat == 1) {
                memcpy(&nonrep_buf[nonrep_count * bpp],
                       prev_pixel, bpp);
                nonrep_count++;

                if (nonrep_count == 255) {
                    rleBuf[rleSize++] = 0;
                    rleBuf[rleSize++] = 255;
                    memcpy(rleBuf + rleSize, nonrep_buf, 255 * bpp);
                    rleSize += 255 * bpp;
                    nonrep_count = 0;
                }
            }
            else {
                rleBuf[rleSize++] = repeat;
                memcpy(rleBuf + rleSize, prev_pixel, bpp);
                rleSize += bpp;
                repeat = 1;
            }

            memcpy(prev_pixel, curr_pixel, bpp);
        }
    }

    if (repeat == 1) {
        memcpy(&nonrep_buf[nonrep_count * bpp],
               prev_pixel, bpp);
        nonrep_count++;
    }
    else {
        rleBuf[rleSize++] = repeat;
        memcpy(rleBuf + rleSize, prev_pixel, bpp);
        rleSize += bpp;
    }

    if (nonrep_count > 0) {
        rleBuf[rleSize++] = 0;
        rleBuf[rleSize++] = nonrep_count;
        memcpy(rleBuf + rleSize, nonrep_buf, nonrep_count * bpp);
        rleSize += nonrep_count * bpp;
    }

    return rleSize;
}


// copy file
static void copy_file(FILE *src, FILE *dst) {
    unsigned char buf[8192];
    size_t n;

    while ((n = fread(buf, 1, sizeof buf, src)) > 0) {
        fwrite(buf, 1, n, dst);
    }
}









// 解压 RLE：从 in (FILE*) 读取压缩像素 → 写未压缩像素到 out (FILE*)
// 要求：hdr 已读入（原始 header），你不能修改 hdr







///////////////////////////////
// PROVIDED CODE
// It is best you do not modify anything below this line
///////////////////////////////
uint32_t brighten_rgb(uint32_t color, int amount) {
    uint16_t brightest_color = 0;
    uint16_t darkest_color = 255;

    for (int i = 0; i < 24; i += 8) {
        uint8_t c = ((color >> i) & 0xff);
        if (c > brightest_color) {
            brightest_color = c;
        }

        if (c < darkest_color) {
            darkest_color = c;
        }
    }

    double luminance = (
        (brightest_color + darkest_color) / 255.0
    ) / 2;

    double chroma = (
        brightest_color - darkest_color
    ) / 255.0 * 2;

    // Now that we have chroma and luminanace,
    // we can subtract the constant factor from each component
    // m = L - C / 2
    double constant = luminance - chroma / 2;

    // find the new constant
    luminance *= (1.0 + amount / 100.0);

    double adjusted = luminance - chroma / 2;

    for (int i = 0; i < 24; i += 8) {
        int16_t new_val = ((color >> i) & 0xff);

        new_val = (((new_val / 255.0) - constant) + adjusted) * 255.0;

        if (new_val > 255) {
            color |= (0xff << i);
        } else if (new_val < 0) {
            color &= ~(0xff << i);
        } else {
            color &= ~(0xff << i);
            color |= (new_val << i);
        }
    }

    return color;
}


