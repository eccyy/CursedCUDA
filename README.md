Prime sieve running serially on cpu vs paralell on gpu

takes same if not longer time on gpu. It takes up O(n) bytes so biggest prime is about 2e9

space complexity makes it not much better on gpu
there's also no locality so there's mostly cache misses 

improvements:
Gpu:
only run on prime numbers you already know instead of breaking if another thread finds out the one you are running isn't prime

both:
run with O(√n) space complexity by using segmented sieve
