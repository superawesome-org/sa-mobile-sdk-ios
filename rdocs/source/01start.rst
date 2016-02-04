Getting started
===============

The first step in integrating the SuperAwesome SDK is to register on the `SuperAwesome Dashboard <http://dashboard.superawesome.tv>`_
and create a new app.

.. image:: img/IMG_01_Dashboard.png

Once your app is registered, you can create placements for it and use the documentation provided below to integrate them into your iOS application.

We also provide some demo placements that can be used for testing. These placements have a 100% fill rate.

============  =====
Placement Id  Description
============  =====
5687          320x50 banner
5692          320x480 interstitial
5740          video
============  =====

Integrate iOS SDK
^^^^^^^^^^^^^^^^^

We use `CocoaPods <http://cocoapods.org>`_ in order to make installing and updating our SDK super easy.
CocoaPods manages library dependencies for your Xcode projects.

Installing CocoaPods
--------------------

If you don't have CocoaPods installed on your machine you can install it by using the following command in your terminal:

.. code-block:: shell

    sudo gem install cocoapods

After that you need to go to the project's directory and initialize CocoaPods

.. code-block:: shell

    cd /project_root
    pod init

Getting the SDK
---------------

The dependencies for your projects are specified in a single text file called a **Podfile**.
CocoaPods will resolve dependencies between libraries, fetch the resulting source code, then link it together in an Xcode workspace to build your project.
To download the latest release of the SDK add the following line to your Podfile:

.. code-block:: shell

    pod 'SuperAwesome'

so it looks something like this:

.. code-block:: shell

    # Uncomment this line to define a global platform for your project
    platform :ios, '6.0'

    target 'MyProject' do
    pod 'SuperAwesome'
    end

After the pod source has been added, update your project's dependencies by running the following command in the terminal:

.. code-block:: shell

    pod update

Don't forget to use the **.xcworkspace** file to open your project in Xcode, instead of the **.xcproj** file, from here on out.

Include project
^^^^^^^^^^^^^^^

Once you've integrated the SuperAwesome SDK, you can access all functionality by including the SuperAwesome header file:

.. code-block:: c++

    #import "SuperAwesome.h"

Prerequisites
^^^^^^^^^^^^^

One thing to note is that sometimes, even though you're accesing SuperAwesome server data through HTTPS, the actual ad content is on HTTP, which on iOS 9+ will cause issues.

To circumvent this, add the following to your .plist file:

.. code-block:: xml

    <dict>
      <key>NSAllowsArbitraryLoads</key>
      <true/>
    </dict>
