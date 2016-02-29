.. [OK] This file should be all about setting up the SDK in your project

Configuring the SDK
===================

Once you've integrated the SuperAwesome SDK, you can access all functionality by including the SuperAwesome header file:

.. code-block:: c++

    #import "SuperAwesome.h"

There are also a few global SDK parameters you can change according to your needs:

=============  ==============  =======
Parameter      Values          Meaning
=============  ==============  =======
Configuration  | Production *  | Whether the SDK should get ads
               | Staging       | from the production or test server.

Test mode      | Enabled       | Whether the SDK should serve test ads or not.
               | Disabled *    | For test placements (30471, 30476, etc) must be Enabled.

MOAT tracking  | Enabled *     | Whether to allow 3rd party tracking
               | Disabled      | through `MOAT <http://www.moat.com/>`_.
=============  ==============  =======
 * = denotes default values

You can leave these settings as they are or change them to fit your testing or production needs.
You can specify them in your *AppDelegate* class or on a View Controller basis.

.. code-block:: objective-c

    #import "SuperAwesome.h"

    @implementation AppDelegate

    - (BOOL) application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

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
