---
layout: page
title: AwesomeAds iOS SDK
permalink: /
---

# iOS Publisher SDK

The iOS Publisher SDK (Software Development Kit) lets you to easily add COPPA compliant advertisements to your apps.

| Info    | Contents  |
|---------|-----------|
| Version   |   {{ site.latest_version }} ([Changelog]({{ site.changelog_url }}))   |
| Support   |   iOS 10.0+         |
| GitHub    |   [https://github.com/SuperAwesomeLTD/sa-mobile-sdk-ios]({{ site.repo }})         |
| Contact   |   [{{ site.email }}]({{ site.email }})        |
| License   |   [GNU Lesser General Public License Version 3]({{ site.license_url }})           |

Here you can quickly jump to a particular page.

<div class="section-index">
    <hr class="panel-line">
    {% for post in site.docs  %}        
    <div class="entry">
    <h5><a href="{{ post.url | prepend: site.baseurl }}">{{ post.title }}</a></h5>
    <p>{{ post.description }}</p>
    </div>{% endfor %}
</div>
