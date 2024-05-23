.PHONY: ssh ssh-key build-vm vm ip clean inventory
.SILENT: output
.DEFAULT_GOAL := help

# Self documenting Makefile
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

ssh-key: ## Generate SSH key, if it doesn't exist
	cd kvm && test ! -e ./id_ed25519 && ssh-keygen -t ed25519 -C "itlab_e2e_ansible" -f id_ed25519 -q -N "" || echo "SSH key already exists, skipping"

vm: ssh-key ## Build and start VM
	kvm/build-vm.sh

ip: ## Read IP address of the VM
	$(eval IP=$(shell sh -c "sudo virsh domifaddr gitlab_e2e_ansible | grep vnet" | awk '{print $$4}' | awk -F / '{print $$1}'))
	echo "IP is $(IP)"

ssh: ip ## SSH to VM
	ssh -l debian $(IP) -i kvm/id_ed25519

gitlab-pass: ip ## Print GitLab root password
	ssh -l debian $(IP) -i kvm/id_ed25519 sudo cat /etc/gitlab/initial_root_password  | grep Password: | awk '{print $$2}'

inventory: ssh-key ip ## Generate Ansible inventory file
	echo "gitlab:\n  hosts:\n    gitlab_omnibus:\n      ansible_user: debian\n      ansible_host: $(IP)\n      become: true\n      ansible_ssh_private_key_file: kvm/id_ed25519" > inventory

ansible: inventory ## Run Ansible playbook
	ansible-playbook playbook.yml -i inventory

browser: ip ## Open GitLab in a browser
	xdg-open http://$(IP)

e2e: vm inventory ansible ## Run all - needs a wait loop for VM provisioning to complete

clean-vm: ## Delete VM
	sudo virsh destroy gitlab_e2e_ansible && sudo virsh undefine gitlab_e2e_ansible && sudo virsh vol-delete --pool default gitlab_e2e_ansible.qcow2 || true
	
clean-all: clean-vm ## Clean all
	rm kvm/id_ed25519* inventory || true