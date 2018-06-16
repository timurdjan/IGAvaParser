# IGAvaParser
Simple parser for full-resolution (upto 1080 px) avatar from Instagram

Usage/Syntax

Usage is pretty simple:

IGAvaParser.parseInstaAvatarFor(accountName: String, completion: ((String?, String?) -> Void))

accountName is just account name :] without '@'etc.

Completion block returns:
- first string is optional full url to avatar's image (equals nil if there is error);
- second string is optional error description (equals nil if there's no errors).
