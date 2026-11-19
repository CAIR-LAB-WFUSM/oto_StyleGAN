import torch
import time

# torch.backends.cuda.matmul.allow_tf32 = True

x = torch.rand(1000, 1000, device="cuda")

# warmup
for _ in range(10):
    y = torch.matmul(x, x)

nb_iters = 1000
torch.cuda.synchronize()
t0 = time.perf_counter()
for _ in range(nb_iters):
    y = torch.matmul(x, x)
torch.cuda.synchronize()
t1 = time.perf_counter()
print("GPU: {}iters/s, {}s/iter".format(nb_iters/(t1 - t0), (t1 - t0)/nb_iters))

x = torch.randn(1000, 1000)
# warmup
for _ in range(10):
    y = torch.matmul(x, x)

t0 = time.perf_counter()
for _ in range(nb_iters):
    y = torch.matmul(x, x)
t1 = time.perf_counter()
print("CPU: {}iters/s, {}s/iter".format(nb_iters/(t1 - t0), (t1 - t0)/nb_iters))