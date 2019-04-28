**************************************************************
* Author: Marco Plaza, 2018
* @nfoxProject, http://www.noVfp.com
* nfTools https://github.com/nfTools
* ver: 20181117:T12:00:00
* ver: 20181120:T22:00:00
* ver: 20181125:T13:00:00
* ver: 20181211:T21:00:00
****************************************************************************************
* This program is part of nfTools, a support library for nFox.
* You are free to use, modify and include it in your compiled projects.
****************************************************************************************
*
* usage ( see _test.prg )
*
*
* with _( object , [ cNewObjectParentPath ] )  && Object = base object you wish to work with; cNewObjectParentPath will add child objects to Object as parents for <newObjectpropertyName>
*
*	.property1 = any valid vfp expression
*
*	.property2 = any valid vfp expression
*
*	with _( .<newObjectPropertyName> [,cNewObjectParentPath] )  && adds a new dynamic object to current object; cNewObjectParentPath will create child objects of parent Object as parents for <newObjectpropertyName>
*		.newObjProperty1 = ...
*		.newObjProperty2 = ...
*
*	endwith
*
*	 .myCollection = .newCollection( [Item1,Item2,... Item20 ]) && creates a quick key-less collection adding up to 20 items at once
*
*	 .myList = .newList( [ Item1,Item2,... Item20 ] ) && creates a one dimension array, optional items to add
*
*	 .additems( "< key-less collection / array name >" , item1,item2,.. item20 ) && adds multiple items to array/ key-less collection
*
*	 with .newItemFor("< collection/array name >" [, collectionItemkey] ) && construct and add objects to array or collection with optional key
*
*		.itemproperty1 = value
*
*		.itemproperty2 = value
*
*	 endwith
*
* endwith
*
*
**************************************************************
parameters __otarget__, cnewobjectparentpath

local emessage,oparent,result,onewobject

try
   emessage = ''

   if vartype(__otarget__) # 'O'
      error 'nfTools: Invalid parameter type - must supply an object '+chr(13)
   endif

   if vartype(m.cnewobjectparentpath) = 'C'
      __otarget__ = createchildsfor( __otarget__ , m.cnewobjectparentpath )
   endif

   result = createobject('nfset', m.__otarget__  )

catch to oerr

   emessage = m.oerr.message

endtry

if !empty(m.emessage)
   error m.emessage
   return .null.
endif

return m.result


******************************************
define class nfset as custom
******************************************
   __otarget__ = .f.
   __lastproperty__ = ''
   __passitems__ = .f.
   dimension __acache__(1)


*------------------------------------------
   procedure error( nerror, cmethod, nline )
*------------------------------------------
   if m.nerror # 1098
      error 'Underscore error '+transform(m.nerror)+' Line '+transform(m.nline)+': '+message()
   else
      error 'Underscore: '+message()
   endif

*----------------------------------------
   procedure init( __otarget__ )
*----------------------------------------

   this.__otarget__ = m.__otarget__


*---------------------------------------------
   procedure this_access( pname as string )
*---------------------------------------------

   if inlist(lower(m.pname),;
         'additems',;
         'newcollection',;
         'newitemfor',;
         'newlist',;
         '__apush__',;
         '__copycache__',;
         '__otarget__',;
         '__lastproperty__',;
         '__acache__',;
         '__passitems__',;
         '__newobject__ ';
         )

      return this

   endif

   this.__copycache__()

   this.__lastproperty__ = m.pname

   if !pemstatus(this.__otarget__,m.pname,5)

      addproperty( this.__otarget__, m.pname, createobject('empty') )

   endif

   return this.__otarget__

*---------------------------------------
   function additems( pname, p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13,p14,p15,p16,p17,p18,p19,p20 )
*---------------------------------------

   local ot,nn,isarray

   if not type( 'this.__oTarget__.'+m.pname,1) $ 'C,A'
      error  pname + ' is not a Collection / Array '
   endif

   isarray = type( 'this.__oTarget__.'+m.pname,1) = 'A'

   ot = this.__otarget__

   for nn = 1 to pcount()-1

      if m.isarray
         this.__apush__( m.ot,m.pname, evaluate('p'+transform(m.nn)) )
      else
         m.ot.&pname..add( evaluate('p'+transform(m.nn)) )
      endif

   endfor


*---------------------------------------
   function newitemfor( pname , key )
*---------------------------------------

   local ot,tvar,onew

   if type('pName') # 'C'
      error ' newItemFor() invalid parameter Type '
   endif

   ot = this.__otarget__

   tvar = type( 'oT.'+m.pname , 1 )

   do case

   case m.tvar = 'C'

      onew = create('empty')

      if pcount() = 2
         m.ot.&pname..add( m.onew, m.key  )
      else
         m.ot.&pname..add( m.onew )
      endif

      return createobject( 'nfset' ,m.onew  )

   case m.tvar = 'A'

      onew = create('empty')

      this.__apush__( m.ot,m.pname, m.onew )

      return createobject('nfset',m.onew)

   otherwise


      error m.pname + ' is not a Collection / Array '

   endcase


*-------------------------------------------------------------------------------------------------------
   procedure newlist( p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13,p14,p15,p16,p17,p18,p19,p20 )
*-------------------------------------------------------------------------------------------------------
   local ot,lp,np

   ot = this.__otarget__
   lp = this.__lastproperty__
   removeproperty(m.ot,m.lp)
   addproperty(m.ot,m.lp+'(1)')

   if pcount() > 0
      dimension this.__acache__( pcount() )
      for np = 1 to pcount()
         this.__acache__(m.np) =  evaluate('p'+transform(m.np,'@b 99'))
      endfor
      this.__passitems__ = .t.
   else
      dimension this.__acache__(1)
      this.__acache__(1) = .null.
      this.__passitems__ = .f.
   endif

   return .null.

*-------------------------------
   procedure destroy
*-------------------------------
   this.__copycache__()


*------------------------------------------
   procedure __copycache__
*------------------------------------------

   if !this.__passitems__
      return
   endif

   this.__passitems__ = .f.

   local aname

   aname = this.__lastproperty__
   acopy( this.__acache__,this.__otarget__.&aname )
   this.__acache__ = .null.

*--------------------------------------
   procedure newcollection(  p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13,p14,p15,p16,p17,p18,p19,p20 )
*--------------------------------------

   local ocol,nn

   ocol = createobject('collection')

   for nn = 1 to pcount()

      ocol.add(  evaluate('p'+transform(m.nn,'@b 99') ))

   endfor

   return m.ocol


*-----------------------------------------
   function __apush__( o, pname , vvalue )
*-----------------------------------------
   local uel

   uel = alen( m.o.&pname )

   if !isnull( m.o.&pname )
      m.uel = m.uel+1
      dimension m.o.&pname( m.uel )
   endif

   m.o.&pname( m.uel ) =  m.vvalue


**********************************************
enddefine
**********************************************

*------------------------------------------------------
function createchildsfor( osrc , cchildspath )
*------------------------------------------------------

local vtype,thispath,thiso,cchildspath
private oo


cchildspath =  alltrim( m.cchildspath,1,'.',' ' )

alines(oo,m.cchildspath,.f.,'.')

m.thiso = m.osrc
thispath = ''

for each thischild in oo

   vtype = type( 'm.thiso.'+m.thischild )

   thispath = m.thispath+'.'+m.thischild

   do case
   case m.vtype = 'U'

      try
         addproperty( m.thiso , m.thischild , createobject('empty') )
         thiso  = m.thiso.&thischild
      catch
         error 'incorrect property Name: "'+m.thischild+'" in '+m.thispath
      endtry


   case m.vtype # 'O' or type( 'm.thiso.'+m.thischild ,1 ) = 'A'
      error m.thispath+' is not an object'

   endcase

endfor

return m.thiso

*----------------------------------------------------------------
