# Introduction #

This will be filled out more as time goes on...


# Details #

```
me:  I am a brand new ISP.
I JUST made my headnode
I want to wire it up to the cloud server, get a correct cert for HN, 
then provision a client.
go.
(the "right" way)
 Thomas:  whose cloud server? your own?
ok, disregard that
we need a certifying authority (ca)
the ca generates/signs all cerrtificates - used in the nodes and those used by clients
so , assuming you are your own ca, sign yourself some certs - give one set of certs to the HN, and another to a client
the radius server also needs certs signed by the same ca
 Sent at 9:25 AM on Thursday
 Thomas:  during the authentication process, the radius server simply checks iff the client certs were signed by the same ca - if so, the client is logged in
are we together?
 me:  ya
 Thomas:  ( so far )
cool - so about the server and node having the same certs
it doesn't really matter because they were signed by the same ca - theoretically, we could give everyone the same cert - 
but for obvious reasons, we don't want to do that

```