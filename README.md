# Ansible Collection - adfinis.gitlab

![License](https://img.shields.io/github/license/adfinis/ansible-collection-gitlab)
![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/adfinis/ansible-collection-gitlab/ansible-lint.yml)
[![adfinis.gitlab on Ansible Galaxy](https://img.shields.io/badge/collection-adfinis.gitlab-blue)](https://galaxy.ansible.com/ui/repo/published/adfinis/gitlab/)


This role deploys GitLab package on Debian server.

To use the role add following to the `requirements.yml`:

```yaml
collections:
  - name: adfinis.gitlab
    version: 1.0.0
```

## Roles

### `adfinis.gitlab.gitlab`

Role is based on [HIFIS GitLab role](https://github.com/hifis-net/ansible-collection-toolkit/tree/main/roles/gitlab).

It adds support for:
- nested keys configuration as list e.g. `- key: ["object_store", "enabled"]`
- deployment of custom pre-receive hooks
- self-signed keys for test/PoC environments

Configuration:

See `roles/gitlab/defaults/main.yml`

Example Playbook:

```yaml
- name: Deploy Gitlab
  hosts: gitlab_server
  tasks:
    - name: Import GitLab role
      ansible.builtin.import_role:
        name: adfinis.gitlab.gitlab
```

## License

[GPL-3.0-or-later](https://github.com/adfinis-sygroup/ansible-collection-gitlab/blob/main/LICENSE)

## Author Information

The Ansible collection `adfinis.gitlab` was written by:

* Adfinis AG | [Website](https://www.adfinis.com/) | [GitHub](https://github.com/adfinis)
