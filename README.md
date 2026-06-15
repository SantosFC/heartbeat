# heartbeat

Serviço systemd que coleta métricas do sistema a cada 5 minutos e envia um ping para o [Healthchecks.io](https://healthchecks.io), permitindo monitorar se a máquina está viva e saudável.

## Arquivos

| Arquivo | Destino | Descrição |
|---|---|---|
| `heartbeat.sh` | `/usr/local/bin/heartbeat.sh` | Script que coleta métricas e envia o ping |
| `heartbeat.service` | `/etc/systemd/system/heartbeat.service` | Unit systemd que executa o script |
| `heartbeat.timer` | `/etc/systemd/system/heartbeat.timer` | Timer que dispara o serviço a cada 5 minutos |

## Métricas enviadas

O script coleta e envia as seguintes informações em JSON:

- `timestamp` — data e hora da execução (ISO 8601)
- `uptime` — tempo de atividade da máquina
- `load` — carga média do sistema (1, 5 e 15 minutos)
- `disk_free` — espaço livre em disco na raiz (`/`)
- `mem_free` — memória disponível

## Instalação

```bash
# Copiar o script
sudo cp heartbeat.sh /usr/local/bin/heartbeat.sh
sudo chmod +x /usr/local/bin/heartbeat.sh

# Copiar os units systemd
sudo cp heartbeat.service /etc/systemd/system/
sudo cp heartbeat.timer /etc/systemd/system/

# Recarregar e habilitar
sudo systemctl daemon-reload
sudo systemctl enable --now heartbeat.timer
```

## Configuração

Antes de instalar, edite `heartbeat.sh` e substitua a URL do ping pela URL do seu check no Healthchecks.io:

```bash
# Linha a editar no heartbeat.sh
https://hc-ping.com/SEU-UUID-AQUI
```

## Verificar status

```bash
# Ver se o timer está ativo
systemctl status heartbeat.timer

# Ver próxima execução
systemctl list-timers heartbeat.timer

# Ver log da última execução
journalctl -u heartbeat.service -n 20
```
