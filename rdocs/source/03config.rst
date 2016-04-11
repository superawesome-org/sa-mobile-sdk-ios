Configuring the SDK
===================

Once you've integrated the SuperAwesome SDK, you can access all functionality by including the SuperAwesome header file:

.. code-block:: c++

    #import "SuperAwesome.h"

There are also a few global SDK parameters you can change according to your needs:

=============  ==============  =======
Parameter      Values          Meaning
=============  ==============  =======
Configuration  | Production *  | If the SDK gets ads from
               | Staging       | the production or test server.
                               | Test placements are all on production.

Test mode      | Enabled       | If the SDK serves test ads. For test
               | Disabled *    | placements (30471, 30476, etc) must be Enabled.
=============  ==============  =======
 * = denotes default values

You can leave these settings as they are or change them to fit your testing or production needs.
You can specify them in your **AppDelegate** class or on a View Controller basis.

.. code-block:: objective-c

    #import "SuperAwesome.h"

    @implementation AppDelegate

    - (BOOL) application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

        [[SuperAwesome getInstance] setConfigurationStaging];
        // [[SuperAwesome getInstance] setConfigurationProduction];

        [[SuperAwesome getInstance] enableTestMode];
        // [[SuperAwesome getInstance] disableTestMode];

        return YES;
    }

    // rest of AppDelegate implementation ...

    @end
