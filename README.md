# CDX-Installer

This repo will install/setup the _CODEXium_ CORE service/software.

To get this CDX-Installer software ...

```
git clone https://github.com/codexium-io/CDX-Installer
```

If you purchased the software, you will recieve a license key.

Use the following steps to install your license key.

e.g.
```
scp CODEXium-CORE-DeployKey-2025-Q4.key cooljoe@woodstock:~ ;
```

Connect to the "woodstock" server.

```
ssh cooljoe@woodstock ;
sudo su - ; # You are now "root"
mv ~cooljoe/CODEXium-CORE-DeployKey-2025-Q4.key ~/.ssh ;
cp ~/.ssh/CODEXium-CORE-DeployKey-2025-Q4.key ~/.ssh/CODEXium-CORE.key ;
# You now have a backup key
chmod 400 ~/.ssh/CODEXium-CORE-DeployKey-2025-Q4.key ;
chmod 400 ~/.ssh/CODEXium-CORE.key ;
```

Now you can use the script "./install.sh" to setup the software.  
If you are installing on a new server dedicated to this software,
you can just accept all the prompts.
You may need to change the server name with the included script.

```
git clone https://github.com/codexium-io/CDX-Installer
cd CDX-Installer ;
./install.sh ;
```

We will have to reboot for some items to fully take effect.
However, We don't need to reboot just yet ... we can change the domain if needed.

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



