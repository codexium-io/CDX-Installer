CDX-Installer
=============

Install Overview
----------------

The installation of CODEXium™ is done via a set of scripts and 
a license key stored in root's ".ssh" directory.

The install scripts are available for download from a public repo.  
The public repo is ...  

<https://github.com/codexium-io/CDX-Installer>

The core CODEXium™ license key can can be purchased from the sales area.
The CODEXium™ core repo, "CDX-CORE", is a private repo only available via license key.


[CODEXium Sales](https://codexium.io/sales.html)




Install Procedure
-----------------

This repo will install/setup the _CODEXium_ CORE service/software.

_CODEXium_ is currently configured to run on Rocky, Alma, CentOS, etc. variants.

To get this CDX-Installer software ...

```bash
git clone https://github.com/codexium-io/CDX-Installer
```

If you purchased the software, you will recieve a license key similar to, for example,
_CODEXium-CORE-2025-Q4.key_ .

Use the following steps to install your license key.

e.g.
```bash
#
# "woodstock" is whatever host you want to install on.
# "cooljoe" is whatever your user account is.
#
scp CODEXium-CORE-DeployKey-2025-Q4.key cooljoe@woodstock:~ 
```

Connect to the "woodstock" server.

```bash
scp CODEXium-CORE-2025-Q4.key cooljoe@woodstock:~
```

Run the following commands (as root):

```bash
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
Afterward, you may need to change the server name with the included script.

```bash
git clone https://github.com/codexium-io/CDX-Installer
cd CDX-Installer ;
./install.sh ;
```

This will set your webserver domain to "**demo.cdx.wiki**"/127.0.0.1.  

NOTE: Microsoft WSL only allows for http://localhost

See section _Changing the Webserver Domain Name_ for details on how
to change the name.

Check the status of the webserver ...

```bash
systemctl status httpd
```

Then, if needed, restart the webserver ...

```bash
systemctl restart httpd
```

Then, if in WSL or if needed, reboot ...

```bash
reboot
```




Changing the Webserver Domain Name
----------------------------------

Let's change the domain from "demo.cdx.wiki" to "something.example.com" ...

```bash
./change_site_name.sh --domain something.example.com
```

OR, interactively ...

```bash
./change_site_name.sh
```

Check the status of the webserver ...

```bash
systemctl status httpd
```

Then, if needed, restart the webserver ...

```bash
systemctl restart httpd
```

Then, if in WSL or if needed, reboot ...

```bash
reboot
```



