## Мониторинг ресурсов в Windows

Для запуска нужно в файле `prometheus.yml` в разделах `targets` указать требуемый IP-адрес, с которого
будут собираться метрики и поочередно запустить:
- `create-containers.cmd`
- `start-metrics.cmd`
- `start-containers.cmd`
