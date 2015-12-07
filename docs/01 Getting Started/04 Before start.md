One thing to note is that sometimes, even though you're accesing SuperAwesome server data through HTTPS, the actual ad content is on HTTP, which on iOS 9+ will cause issues.

To circumvent this, add the following to your .plist file:

```
<dict>
	<key>NSAllowsArbitraryLoads</key>
	<true/>
</dict>

```
