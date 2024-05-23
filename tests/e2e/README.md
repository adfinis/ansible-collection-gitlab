# e2e testing with KVM

## Requirements

Tested on Debian host with default KVM installation.

## Help

Run `make`

## Execute

### Build VM

```
make vm
```

### SSH to VM

```
make ssh
```

### Deploy GitLab role

```
make ansible
```

### Display GitLab root password

```
make gitlab-pass
```

### Open GitLab in a browser

```
make browser
```
