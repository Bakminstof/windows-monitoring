## Мониторинг ресурсов в Windows

Для запуска нужно в файле `prometheus.yml` в разделах `targets` указать требуемый IP-адрес, с которого
будут собираться метрики и поочередно запустить:
- `create-containers.cmd`
- `start-metrics.cmd`
- `start-containers.cmd`

Далее в Grafana необходимо data source Prometheus http://prometheus:9090/ и добавить парочку дашбордов через импорт в 
- 14510
- 14694


Blackbox exporter http://localhost:9115/
Windows exporter http://localhost:9182/
Prometheus http://localhost:9090/
Grafana http://localhost:9090/
