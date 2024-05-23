# Example deployment with collection installed from GitHub

## Set up

Requries a host and valid inventory file. This example reuses VM from `tests/e2e` but installs GitLab using upstream collection.

If you don't have a host, follow next section, otherwise skip.

## Set up VM using e2e tests

```
cd <to-repo-dir>

cd tests/e2e
make vm
sleep 15
make inventory

cd <to-repo-dir>

cd example
cp ../tests/e2e/inventory .
mkdir kvm
cp ../tests/e2e/kvm/id_ed25519 kvm/

# test access
ansible -i inventory gitlab -m ping
```

## Install collections

```
ansible-galaxy collection install -r .
```

## Modify configuration

Edit `group_vars/gitlab/main.yml`

## Apply role

```
ansible-playbook playbook.yml -i inventory
```
