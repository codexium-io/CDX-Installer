# CDX-Installer

This repo will install/setup the _CODEXium_ CORE service/software.

_CODEXium_ is currently configured to run on Rocky, Alma, CentOS, etc. variants.

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
scp CODEXium-CORE-2025-Q4.key cooljoe@woodstock:~
ssh cooljoe@woodstock ;
sudo su - ; 
mkdir ~/.ssh 2>/dev/null ;
chmod 700 ~/.ssh ;
mv ~cooljoe/CODEXium-CORE-2025-Q4.key ~/.ssh ;
chmod 400 ~/.ssh/CODEXium-CORE-2025-Q4.key ;
cp ~/.ssh/CODEXium-CORE-2025-Q4.key ~/.ssh/CODEXium-CORE.key ;
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

This will set your webserver domain to "demo.cdx.wiki"/127.0.0.1.

We will have to reboot for some items to fully take effect.
However, We don't need to reboot just yet ... we can change the domain if needed.

Let's change the domain from "demo.cdx.wiki" to "something.example.com" ...

```
./change_site_name.sh --domain something.example.com
```

OR, interactively ...

```
./change_site_name.sh
```

Check the status of the webserver ...

```
systemctl status httpd
```

Then, if needed, restart the webserver ...

```
systemctl restart httpd
```

Then, if in WSL or if needed, reboot ...

```
reboot
```



