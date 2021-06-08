# RDPY 

Remote Desktop Protocol in twisted python.

RDPY is a pure Python implementation of the Microsoft RDP (Remote Desktop Protocol) protocol (client and server side). RDPY is built over the event driven network engine Twisted. RDPY support standard RDP security layer, RDP over SSL and NLA authentication (through ntlmv2 authentication protocol).

RDPY provides the following RDP and VNC binaries :
* RDP Man In The Middle proxy which record session
* RDP Honeypot
* RDP screenshoter
* RDP client
* VNC client
* VNC screenshoter
* RSS Player

## Build

RDPY is fully implemented in python, except the bitmap decompression algorithm which is implemented in C for performance purposes.

### Dependencies

Dependencies are only needed for pyqt4 binaries :
* rdpy-rdpclient
* rdpy-rdpscreenshot
* rdpy-vncclient
* rdpy-vncscreenshot
* rdpy-rssplayer

### Docker RUN CMD

docker run -e ip="Open Distro for Elasticsearch IP" -e user="Open Distro for Elasticsearch user" -e password="Open Distro for Elasticsearch password" -d -p 3389:3389 kkpkishan/rdpy:latest
