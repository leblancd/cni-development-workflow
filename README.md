# cni-development-workflow
An overview of development workflow for Container Networking Interface (CNI) Plugins.

These instructions assume that you have a linux server on which to build, and that server has Go language installed, and the $GOPATH is configured appropriately.

## Create Your Own Fork of containernetworking/plugins:

	* Go to the [CNI Plugins Repo](https://github.com/containernetworking/plugins/)
	* Log into github if you aren't already logged in.
	* Select <Fork> button

## Git Clone Your Fork of containernetworking/plugins:

On a linux server that you will use as your build server, create a clone
of your containernetworking/plugins fork using the git_clone_plugins.sh
script:

```bash
cd
git clone https://github.com/leblancd/cni-development-workflow
cd cni-development-workflow
./git_clone_plugins.sh <your-github-username>
```

## Creating a Task Branch to Work on a Feature

```
cd $GOPATH/src/github.com/containernetworking/plugins/
git checkout -b myfeature
```

## Syncing With Latest Upstream:

While on your myfeature branch
```bash
git fetch upstream
git rebase upstream/master
```

## Commiting Changes

For the initial commit of your changes:
```bash
git commit
git commit -a
```

## Adding to / Amending an Existing Commit:

If you're already done a commit, and you want to add to / amend it:
```bash
git commit -a --amend
```

## Push to Your Forked Branch:

```bash
git push -f origin myfeature
```

## Creating a Pull Request:

Please review the containernetworking/plugins [How to Contribute Guide](https://github.com/containernetworking/plugins/blob/master/CONTRIBUTING.md) before creating a pull request.

After you've pushed up your changes to your github fork of containernetworking/plugins, you can create a pull request as follows:

	1. Visit your fork at github, e.g. https://github.com/<your-github-username>/plugins
	2. Click the <Compare & pull request> button next to your myfeature branch.
	3. Check out the pull request process for more details.

## Running Test Suites on a Vagrant-Created VM:

Here's how you can run the test suite on any system (even Mac or Windows) using
 [Vagrant](https://www.vagrantup.com/) and a hypervisor of your choice (e.g. VirtualBox):

```bash
vagrant up
vagrant ssh

# you're now in a shell in a virtual machine
sudo su
cd /go/src/github.com/containernetworking/plugins

# to run the full test suite
./test

# to focus on a particular test suite
cd plugins/main/loopback
go test
```

## Running Tests Directly on a Host Machine:

 * Some tests must be done as root (e.g. they create namespaces for testing), so create a  local repo that is owned by root.
 * cd to the package of interest
 * Run 'go test'

## Building Binaries (e.g 'bridge' and 'host-local' plugins):

```bash
cd $GOPATH/src/github.com/containernetworking/plugins
./build
```

## Copying Binaries to Kubernetes Master and Minions (with Backup):

This assumes that you have password-less ssh/scp set up (including /etc/hosts entry) for user kube on kube-master, kube-minion-1, and kube-minion-2.

 * Git clone this repo to get the backup_and_copy_binaries.sh script, if you haven't done so already:
```bash
cd
git clone https://github.com/leblancd/cni-development-workflow
```
 * Run the backup_and_copy_binaries.sh script:
```bash
cd ~/cni-development-workflow
./backup_and_copy_binaries.sh
```
