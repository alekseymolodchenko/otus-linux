# Linux Administrations Course

## HW #5 - Linux processes management

- Скрипт реализует запуск конкурирующих процесса по IO и CPU

```bash
  #!/bin/bash

  set -x

  cleanup() {
    echo "Starting cleanup..."
    rm -f /tmp/tmp.file*
    echo "Cleanup complete..."
    exit
  }

  trap cleanup SIGHUP SIGINT SIGTERM EXIT

  xargs -P 2 -I {} sh -c 'eval "$1"' - {} <<'EOF'
  time dd if=/dev/urandom of=/tmp/file.$RANDOM bs=2M count=1048
  time nice -n 19 ionice -c2 -n7 dd if=/dev/urandom of=/tmp/file.$RANDOM bs=2M count=1048
  EOF

  cleanup

  ```

- Hеализована обработка сигналов SIGHUP SIGINT SIGTERM EXIT

 <details><summary>Результаты запуска</summary><p>
  
  - htop
  ![htop](https://i.imgur.com/ZU9xua1.png)

  - iotop
  ![iotop](https://i.imgur.com/W3JtyPp.png)

  </p></details>

 <details><summary>Лог консоли</summary><p>

    otuslinux: + trap cleanup SIGHUP SIGINT SIGTERM EXIT
    otuslinux: + xargs -P 2 -I '{}' sh -c 'eval "$1"' - '{}'
    otuslinux: 1048+0 records in
    otuslinux: 1048+0 records out
    otuslinux: 2197815296 bytes (2.2 GB) copied, 44.6668 s, 49.2 MB/s
    otuslinux: 
    otuslinux: real     0m44.673s
    otuslinux: user     0m0.013s
    otuslinux: sys      0m39.222s
    otuslinux: 1048+0 records in
    otuslinux: 1048+0 records out
    otuslinux: 2197815296 bytes (2.2 GB) copied, 45.0834 s, 48.8 MB/s
    otuslinux: 
    otuslinux: real     0m45.092s
    otuslinux: user     0m0.009s
    otuslinux: sys      0m39.420s
    otuslinux: Starting cleanup...
    otuslinux: + cleanup
    otuslinux: + echo 'Starting cleanup...'
    otuslinux: + rm -f '/tmp/tmp.file*'
    otuslinux: Cleanup complete...
    otuslinux: Starting cleanup...
    otuslinux: + echo 'Cleanup complete...'
    otuslinux: + exit
    otuslinux: + cleanup
    otuslinux: + echo 'Starting cleanup...'
    otuslinux: + rm -f '/tmp/tmp.file*'
    otuslinux: Cleanup complete...
    otuslinux: + echo 'Cleanup complete...'
    otuslinux: + exit

  </p></details>
