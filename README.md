# active_stripper
Small gem that allow preprocessing of field (remove emoji, strip...) by creating prepended custom accessors.
Only works on ruby 2.x since the prepend instruction is used.

Named active_stripper for search purposes (that and because I <3 pun) but doesn't depend on active record method and can be used any attr_accessor in any class.

It defines setter methods but you can still use your owns in the class definition, the one generted from the gem will be called last though.
