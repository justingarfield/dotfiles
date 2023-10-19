# Power Settings

The Windows 11 Power settings are a bit scattered at the time of this writing. A couple of settings live under **Settings** -> **System** -> **Power**, but then the remainder of power settings still live under the old Control Panel widgets.

## System Settings

Under the new System Settings area, you can configure Screen and Sleep durations.

By default, you'll see a drop-down for Power Mode as well, which lets you pick from three differing options. The important thing to know about this setting, is that you're actually adjusting settings of the underlying "Balanced" power profile, which truly lives over in the Control Panel realm still.

## Control Panel Settings

If you want to truly tweak full power options for Windows 11, you need to visit **Control Panel** -> **System and Security** -> **Power Options**

### Choose what the power buttons do

Depending on the type of device / machine, and the purpose it serves, you're going to want to tailor the options on this screen to your personal preference.

#### Power and sleep button settings

On my beefier workstations that are running 24/7 containers, caching databases, etc. I choose to set the Power Button and Sleep button _(if my keyboard or PC case has one)_ to `Do nothing`; as I will never be shutting down these machines with the power button _(you can still hold them down for 5-seconds for a hard-shut down at the mobo level)_, nor will I ever sleep or hibernate them. If I ever need to do a full shutdown, I will use the Windows shut-down menu option like a normal shut-down.

On my laptops, I choose to set the Power Button to `Shut down` and the Sleep Button to `Hibernate` (regardless of On Battery vs. Plugged in). I choose Hibernate over Sleep because I'll usually be moving / traveling with my laptop at that point, and should I get stuck in traffic or delayed, I want my session state to stick-around should my battery fully die.

On laptops, I also set When I close the lid to be `Do nothing` as I'm usually just carrying the laptop from one room/seat to another.

**Interesting Note:** When you update these settings via Control Panel, it's actually updating EVERY Power Scheme in the background. You can, however, use `powercfg.exe` to target a specific Power Scheme individually _(isn't Agile just wonderful? LOL!...wtf)_.

#### Shutdown settings

To adjust the settings under this section, you'll need to click on `Change settings that are currenty unavailable` at the top of the Control Panel screen.

* Turn on fast startup (recommended)
  * If you're on a spinning HDD or Hybrid HDD/SSD, I would recommend keeping this checked
  * If you're on a decent SSD or newer M.2 NVMe drive, I would uncheck this _(this is just my personal preference)_
* Sleep
  * On beefier desktops, I disable sleep, so I uncheck this option
  * On laptops, I don't use sleep, so I uncheck this option
* Hibernate
  * On beefier desktops, I disable sleep, so I uncheck this option
  * On laptops, I use Hibernate, so I leave this checked
* Lock
  * I uncheck this option, as I personally don't want to allow random people to perform Shut downs or Hibernate without a logged-in session / unlocked machine
