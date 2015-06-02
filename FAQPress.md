

# What is the quality of the Internet access in Afghanistan right now? #

Internet access in Afghanistan varies in quality and price.  Generally speaking it is possible for a regular person in a major city to purchase internet for their home.  However there is no concept of service uptime guarantees, so often there may be long periods of outages and very inconsistent speed performance.  ISP's often run internet cafes as well with the same connectivity difficulties.  Some international companies install private satellite connections and often times Afghans employed by these companies are allowed to use the computers at work for email; even these are often not terribly fast and the total satellite capacity into the region is nearly maximized already.

# In which sense can FabFi project help? #

With all of the difficulties, one of the biggest hinderances to internet access is simply perception of complexity and cost.  More and more people own computers, laptops, or smartphones but don't understand networking.  FabFi can help in two ways.  One is to lower the perceived "barrier for entry" by teaching and sharing the FabFi system, and the other is by allowing people to come together to share the bandwidth from an uplink or local content server.


# Is it difficult for people with no extensive technological knowledge? #

The FabFi system is a project using commercial IEEE 802.11 devices and home made reflectors to create long(er) range connections and networks.  While specific, extensive knowledge is not necessary, general familiarity with using a computer, using or installing 12V DC power lines, and following written tutorials (at the moment all in English) are necessary unless the new user has access to someone who has done it before.

One of the reasons we chose 802.11 radios (commonly known as "wireless devices") is that in most/all countries 2.4, 3.6 and 5 GHz frequency bands are available for unlicensed use. The underlying processes and technologies will work at other frequencies so you can adapt and/or bridge other devices into the network.  Another reason is that 802.11 devices are easily available for purchase by ordinary consumers in most countries.

In Afghanistan, the initial project work was done in the Fab Lab (it is the Fab Lab's internet connection that is being shared with the FabFi users; the name FabFi is from "FabLab" and "WiFi").  The Fab Lab provides access to digital fabrication equipment and opportunities for people to use them hands-on for whatever projects they wish.  The teaching and learning in the fab lab is accomplished peer-to-peer, and in this manner the knowledge and ability to make and install additional routers is spread.


# What are your motivations to set up this project? #

Since approximately 2001 I have been involved in setting up Fab Labs around the globe to see what people make - the projects tackled are always user-initiated and therefore probably meaningful in the local context.  In many places communications related projects have been popular.  In Afghanistan municipal services are often not robust and do not service outside of a small region, usually close to the center of the city (or the center of wealth in a city).  The Fab Lab was originally built just outside of a city so it did not have power or running water and very marginal cell service.  Our users very much wanted to be able to extend the internet and connectivity of the Fab Lab to a nearby school and their homes.  In Afghanistan (and later Kenya) this desire to meet their own communications needs was met by building on previous Fab users' communications projects from distant places such as Norway, Greece, and India.


# Can you explain some concrete case of success using FabFi, perhaps a great experience of a user? #

The best story is that two of our most experienced FabFi builders (they have shown many of their friends how to add in to the network) demonstrated that they fully understood the system when they were able to cobble together a reflector of their own design using "trash" material.  They did this completely on their own and tried it out to show that it would work, then surprised us with photos afterwards.  Third world education systems are often criticized for producing people who only know "rote" learning, that is exact copying or mimicking rather than comprehension.  While we made the FabFi design and guides so that you could just follow the instructions without understanding the technical details, these guys obviously "really" learned.

# Some of your project was funded by the National Science Foundation, a US government agency.  Doesn't that mean it's really another secret US plot to control and undermine foreign governments? #

Our tax dollars pay for a diversity of things; the presence of US funding does not imply subversive intent.  The fab lab in Jalalabad was established with NSF funds as part of our technological outreach  project to see what people in a conflict / reconstruction area would make with access to digital fabrication technologies.  While users also made many other projects, they have clearly shown that communications is sufficiently important to them that they have put in great effort to implement the FabFi system.



# How did the idea of creating this come and when ? #

The very beginnings (2001) were a northern Nordic sheep farmer wanting to make a way to track his sheep, which included sending vital signs back to the farm.  Over time the target application changed but there has always been a shared need to move information across distances at low powers, and done easily with reasonably available materials.  Many different collaborators have experimented with making or hacking every part of the system from the antennas, radios, software, routers, and even the routing protocols and transmission medium.

# How is it different from the "Internet in a suitcase" project ? #

I don't know too much about the "internet in a suitcase" other than the description in the NYT.
Two obvious differences: 1) FabFi (and fab lab projects) are about having locals make use of what is available locally.  Both of these appears to be direct opposition to the conops of the internet in a suitcase where I assume outsiders come with a suitcase full of parts, both from outside the locality.  This necessarily means that their system cannot grow beyond the number of parts that arrived in the suitcase.  2) FabFi systems in various forms and scales exist in several sites across several countries, is open source / freely and openly described, and systems have operated successfully for years.

# Can anyone create it ? What are the "ingredients" ? #

FabFi is a collection of (other open source) tools running on a mix of ordinarily available or easily fabricate-able hardware.

At the most basic level, it is a hacked "access point" (which broadly speaking converts wireless radio frequency (RF) signals to digital data for computer communications.  The available hacks are modifications designed to substantially increase range, share bandwidth, etc. depending on the local needs.  Most fabfi implementations also include services within the network to better allow sharing, metering, optimizing, etc.  All of these tools and capabilities are like on a menu and the key contribution of FabFi is to have glued these capabilities together AND aggressively shared the experiences and how-tos with CC-BY licensed tutorials and website and making all of the firmware, mechanical designs, etc. freely available in simple packages for download under GNU GPL.

# What is it really used for ? Do you have information on the users' profiles and what they do online ? #

There's a balance of privacy and data collection / evaluation for shaping network performance.  In most implementations, the gateway server(s)  explicitly strip unique identifiers such as MAC addresses out before any system logging.  Because our system is open and free to duplicate and extend by anyone, there are implementations that we didn't not create and don't control how people use.

In terms of thinking about network resources and performance, we do need to know how much traffic is, for example, "real time" like for skype calls or streaming video, "unique data" as in email, or "static" like accessing a web page that rarely changes.  Some of that kind of data is tracked by the proxy server (another open source package).  In Jalalabad the FabFi network goes well out of the way to keep data anonymized; we definitely see a lot of activity that is probably Skype (brand in-specific), and much more downloading than uploading.   In Kenya, which hasn't really been up long enough to make generalizations, I think we're starting to see a lot more streaming videos and downloads and less real time communications.  This may be because the cell phone call costs are ridiculously inexpensive due to the cell carrier wars.

Thus far, many of the technical people involved have not had social science-y interests such as "what do people do online"; they only care about the answer to this question from a bandwidth allocation point of view.  But we're starting to have people talk about this, and I welcome discussions and thoughts about how to do this kind of research without "breaking" the "developer-owner-operator-community" spirit of the networks or violating expected privacy expectations.


# Do you think it has a potential to help dissidents raise their voices or not yet ? #

In a sense, yes.  Because you can't "unlearn" what you know, working at any level with the FabFi system necessarily sheds light on the "how it works" aspects of a technology and infrastructure that is usually concealed inside boxes.  Whether it be simply on vacation and away from home, during a natural disaster, or times of great unrest and distress, knowing how any communications systems work gets you very far in cobbling together something in a pinch… or longer.

# It is not something new. However, we talk a lot about it these days. Do you have any opinion on the reason of this ?   Why choosing Afghanistan for the project ?  Why choose this project? #

The FabFi project, especially in Afghanistan, has gotten a lot of attention (even though I always tell reporters of the equally large and completely sustainable/profitable system in Kenya that seems rarely mentioned).  I think a part of it has to do with it seeming so much more difficult in Afghanistan, maybe because you hear about NATO, UN, ISAF, etc. addressing the same problem space and the image of "a bunch of kids" doing it themselves is so inspiring, especially in comparison to the usually depressing and cynical view of those large organizations.

The real, bigger "project" is the thing called a Fab Lab.  There are just over 100 of them globally and there is also one in Jalalabad.  A fab lab is both a place and a part of a much larger global human network of people using current or just-at-the-edge technologies in clever ways to address their very immediate needs and concerns.  (An example is to say that you do not personally need to know how your computer and printer work but can use them quite competently.  The tools in the lab only sound very technical, but we've had great success at teaching all kinds of people from all over the world to use them competently.  I believe it is only a lack of access that prevents more people from making extraordinary impacts -- imagine if today there were in total only 100 computers and 100 printers to share among the whole planet).

No person or lab is directed to work on any particular project area.  (In the very early years, 2001-2004, my department at MIT seeded some labs with National Science Foundation (NSF) funding just to see what people would make or do.)  In Afghanistan it's not terribly surprising that people wanted to extend what we could consider "municipal" services to their houses - this included things like making battery operated lights/lamps/flashlights, battery charging circuits - again these things are rarely of interest to the media while being transformatively important to individuals.  I think in part because it's only a very localized, personal tragedy to not have lighting at night and it is something that people think they could clearly solve (ie, go buy a battery powered or petrolmax lamp).  Amidst report about insurgents shutting down communications towers, that's not something so easy to just fix… so it's kind of awesome that, well, in some ways, it can.

That image of "doing for yourself" when the "Government" has failed to provide for you is instinctually compelling and more so when it's a seemingly difficult, "magical" technical thing.  Perhaps because of that, there is an associated, inexplicable taboo about taking monies or other support to get it going.  We aren't, and shouldn't be, afraid to talk and even mingle with "the adults".  A fear is that  with any involvement,"they" will surreptitiously take over but I think we have to face this head on rather than avoid it.  It is almost funny that in reality, whenever we've talked to "adults" they dismiss these kinds of projects as being too small to have an effect and unscalable (that's not true from a technical perspective).

# How can someone make a business from this, are they allowed to do that? #

All of the software and hardware used in the FabFi project are open source under various licenses; most of the FabFi contributions to put it together as a system are CC-BY which allows others distribute, remix, tweak, and build upon your work, even commercially, as long as we are credited for the original creation as appropriate. Everything is freely available to download at http://fabfi.fabfolk.com

# What are the current FabFi capabilities and what are the plans for the future? #

The current FabFi version 4.0 includes billing capability, much improved networking monitoring, and the use and testing of Ubiquity devices, was deployed in 2010 in pilot in a community in Kenya. The pilot aimed to establish a self-sustaining-with-growth business that would build and maintain a free-to-fee network. Free-to-fee means their network was designed so that basic access to the internet and educational materials are free and they collect fees only for high speed unrestricted service. They have reached a critical mass of subscribers for self-sustainability and are now tackling growth. In the ensuing months our networks in Afghanistan and Kenya received much press and we have gotten a lot of technical volunteers to develop the system further.

FabFi version 5.0 (slated for late fall 2011) is predominately focused on scaling (to tens and hundreds of thousands of nodes and several hundreds of thousands of devices) and locally hosted educational/informational/contextual content (so that as long as your city-scale intranet is up, persistent connection to the big internet becomes less important).

The software and system architecture allows anyone to connect for free for either low-speed, local, or educational content (that you can select and change as a community or a managed operator) while allowing people to chose to pay by-the-hour or by subscription for high speed unrestricted access. The hope is in some situations to be able to pay for the “free” with the “fee” parts.

With FabFi 5.0 we’re expecting to have a pretty great infrastructure but we haven’t forgotten that it’s only as good as the content and services available in the network. A substantial part of the development work has to do with the technologies of local caching and mirroring as well as the pedagogical aspects of the content itself.

# What are the hallmarks of "the next version"? #

Massively larger number of nodes and devices (order 1000 to 2000) and aggressive content serving from within the mesh

# Are there FabFi installations elsewhere in addition to Jalalabad? #

Yes.  A list of past, current, and planned locations can be found at http://code.google.com/p/fabfi/wiki/Locations

# Is there a blog, website, group, etc. for this project? #
Yes, they are all linked from our main website, http://fabfi.fabfolk.com
The blog is http://fabfiblog.fabfolk.com/
The project source code is at http://code.google.com/p/fabfi/
The FabFi Enthusiasts group is http://groups.google.com/group/fabfi
There are several Facebook groups, the general one is named “FabFi” (http://www.facebook.com/groups/140474289914/)