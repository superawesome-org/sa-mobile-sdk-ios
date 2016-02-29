.. [OK] This file should be all about setting up the SDK in your project

Configuring up the SDK
======================

Once you've integrated the SuperAwesome SDK, you can access all functionality by including the SuperAwesome header file:

.. code-block:: c++

    #import "SuperAwesome.h"

There are also a few global SDK parameters you can change according to your needs:

=============  =====================  ==========  =======
Parameter      Values                 Default     Meaning
=============  =====================  ==========  =======
Configuration  Production or Staging  Production  Whether the SDK should get ads from the production or test server.
Test mode      Enabled or Disabled    Disabled    Whether to serve test ads for the placement or not. For placement in the first section, must be Enabled.
MOAT tracking  Enabled or Disabled    Enabled     Whether to allow 3rd party tracking through `MOAT <http://www.moat.com/>`_.
=============  =====================  ==========  =======

You can leave these settings as they are or change them to fit your testing or production needs.
You can specify them in your *AppDelegate* class or on a View Controller basis.

.. code-block:: objective-c

    #import "SuperAwesome.h"

    @implementation AppDelegate

    - (BOOL) application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

      [[SuperAwesome getInstance] setConfigurationStaging];
      // or
      // [[SuperAwesome getInstance] setConfigurationProduction];

      [[SuperAwesome getInstance] enableTestMode];
      // or
      // [[SuperAwesome getInstance] disableTestMode];

      [[SuperAwesome getInstance] enableMoatTracking];
      // or
      // [[SuperAwesome getInstance] disableMoatTracking];

      return YES;
    }

    // rest of AppDelegate implementation ...

    @end
