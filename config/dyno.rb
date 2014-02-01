WORKER_NUM = (ENV['WORKER_NUM'] || 3).to_i

worker_mem = (ENV['WORKER_MEM'] || 512).to_i * (1024 ** 2) # 512 is 1 dyno memory size
mem_per_worker = worker_mem / WORKER_NUM
WORKER_MEM_MIN = (mem_per_worker * (ENV['WORKER_MEM_MARGIN'] || 0.9).to_f).to_i
WORKER_MEM_MAX = mem_per_worker

WORKER_CHECK_CYCLE = (ENV['WORKER_CHECK_CYCLE'] || 16).to_i
