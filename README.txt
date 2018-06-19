POD Install Procedure:

[ 1 ] Open terminal and type:

sudo gem install cocoapods
Gem will get installed in Ruby inside System library. Or try on 10.11 Mac OSX El Capitan, type:

```sudo gem install -n /usr/local/bin cocoapods```

If there is an error "activesupport requires Ruby version >= 2.xx", then install latest activesupport first by typing in terminal.

```sudo gem install activesupport -v 4.2.6```

[ 2 ] After installation, there will be a lot of messages, read them and if no error found, it means cocoapods installation is done. Next, you need to setup the cocoapods master repo. Type in terminal:

```pod setup```

And wait it will download the master repo. The size is very big (370.0MB at Dec 2016). So it can be a while. You can track of the download by opening Activity and goto Network tab and search for git-remote-https. Alternatively you can try adding verbose to the command like so:

```pod setup --verbose```

[ 3 ] Once done it will output "Setup Complete", and you can create your XCode project and save it.

[ 4 ] Then in terminal cd to "your XCode project root directory" (where your .xcodeproj file resides) and open your project's podfile by typing in terminal:

```open -a Xcode Podfile```

When you are done editing the podfile, save it and close XCode.

[ 5 ] Then install pods into your project by typing in terminal:

```pod install```

Depending how many libraries you added to your podfile for your project, the time to complete this varies. Once completed, there will be a message that says

"Pod installation complete! There are X dependencies from the Podfile and X total pods installed."