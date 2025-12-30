# 生成一些数据，放入名为“mydata”的文件中
#./gen 100 R > mydata
# 使用 sortA 对数据进行排序，将结果放入“sortedA”中
./sortA < mydata > sortedA
# 使用 sortB 对数据进行排序，将结果放入“sortedB”中
./sortB < mydata > sortedB
# 使用 Unix sort 对数据进行排序
sort -n < mydata > sorted
# 检查 sortA 和 sortB 程序是否实际排序
# 运行大型排序并丢弃结果# 重复上述操作，但获取 sortA 的计时数据# 重复计时，但使用更好的输出格式diff sorted sortedA # should show no diffs
#diff sorted sortedB # should show no diffs

#./gen 100000 R | ./sortA > /dev/null

#./gen 100000 R | time ./sortA > /dev/null

#./gen 100000 R | /usr/bin/time --format="%U seconds" ./sortA > /dev/null

#sh timeit sortA
#sh timeit sortB