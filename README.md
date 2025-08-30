# CDX-Installer

This repo will install/setup the _CODEXium_ CORE service/software.

To get this CDX-Installer software ...

```
git clone https://github.com/codexium-io/CDX-Installer.git
```

If you purchased the software, you will recieve a license key.

* Copy your license key, as root, to your host "MyCoolServer:~/.ssh/" . 
* Copy the license key to the target file name .
* Change the mode to read-only on the original license key .  
  (You now have a backup key.)
* Change the mode to read-only on the target file name .

OR, you can just copy the following and run it.

e.g.
```bash
scp CODEXium-CORE-DeployKey-2025-Q4.key CoolJoe@MyCoolServer:~/.ssh/ ;
# You may need to move the key, as root, from the "CoolJoe"
# user directory into root's .ssh directory.
sudo su - ;
mv ~CoolJoe/.ssh/CODEXium-CORE-DeployKey-2025-Q4.key ~/.ssh ;
cp ~/.ssh/CODEXium-CORE-DeployKey-2025-Q4.key ~/.ssh/CODEXium-CORE.key ;
# You now have a backup
chmod 400 ~/.ssh/CODEXium-CORE-DeployKey-2025-Q4.key ;
chmod 400 ~/.ssh/CODEXium-CORE.key ;
```

Now you can use the script "./install.sh" to setup the software.  
If you are installing on a new server dedicated to this software,
you can just accept all the prompts.
You may need to change the server name with the included script.

```
cd CDX-Installer ;
./install.sh ;
```

NOTE: You will have to reboot for the disabled SELinux to take effect.

We don't need to reboot just yet ... we can change the domain if we need to.

Let's change the domain from demo.cdx.wiki to "something.example.com" ...

```
./change_site_name.sh --domain something.example.com
```

OR, interactively ...

```
./change_site_name.sh
```

Then restart the webserver ...

```
systemctl restart httpd
```

Then reboot ...

```
reboot
```



