**************************************************************
* Marco Plaza, 2018
* @nfoxProject, http://www.noVfp.com
* nfTools https://github.com/nfTools
* rev: 20181117:T12:00:00
* rev: 20181120:T22:00:00 
*************************************************************
*
* usage ( see _test.prg )
*
*
* with _( object , [ cNewPropertyName ] )
*
*	.property1 = any valid vfp expression
*
*	.property2 = any valid vfp expression
*
*	with _( .<newObjectPropertyName> [,cNewpropertyName] )
*
*	endwith
*
*	 .myCollection = .newCollection( [Item1,Item2,... Item20 ]) 
*
*	 .myList = .newList( [ Item1,Item2,... Item20 ] )
*
*	 .additems( "< collection/array name >" , item1,item2,.. item20 )
*
*	 with .newItemFor("< collection/array name >" [, collectionItemkey] )
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

Parameters __otarget__, newpropname

Private All

Try

	emessage = ''

	Do Case

	Case type('__otarget__',1) = 'A' or vartype(__otarget__) # 'O'
		Error 'nfTools: Invalid parameter type - must supply an object '+Chr(13)
		result = .Null.


	Case Pcount() = 2 And Vartype( m.newpropname ) = 'C'

		tact = Type( '__oTarget__.'+newpropname )

		Do Case
		Case m.tact = 'U'
			AddProperty( __otarget__ , newpropname, Createobject('empty') )
		Case m.tact # 'O'
			__otarget__.&newpropname = Createobject('empty')
		Endcase

		result = Createobject('nfset',__otarget__.&newpropname)

	Otherwise

		result = Createobject('nfset',m.__otarget__)

	Endcase

Catch To oerr

	emessage = emessage( oerr)


Endtry

If !Empty(m.emessage)
	Error m.emessage
	Return .Null.
Endif


Return m.result



******************************************
Define Class nfset As Custom
******************************************
__otarget__ = .F.
__lastproperty__ = ''
__passitems__ = .F.

*----------------------------------------
Procedure Init( __otarget__ )
*----------------------------------------
	This.__otarget__ = m.__otarget__
	AddProperty(This,'__acache__(1)')

*---------------------------------------------
Procedure this_access( pname As String )
*---------------------------------------------

	If inlist(Lower(m.pname),;
	'additems',;
	'newcollection',;
	'newitemfor',;
	'newlist',;
	'__apush__',;
	'__copycache__',;
	'__otarget__',;
	'__lastproperty__',;
	'__acache__',;
	'__passitems__';
	)
	
		Return This
	Endif

	This.__copycache__()

	This.__lastproperty__ = m.pname

	If !Pemstatus(This.__otarget__,m.pname,5)

		AddProperty(This.__otarget__,m.pname, Createobject('empty') )

	Endif

	Return This.__otarget__

*---------------------------------------
Function additems( pname, p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13,p14,p15,p16,p17,p18,p19,p20 )
*---------------------------------------

	local ot,nn,isarray
	
	If Not Type( 'this.__oTarget__.'+m.pname,1) $ 'C,A'
		Error  pname + ' is not a Collection / Array '
	Endif

	isarray = Type( 'this.__oTarget__.'+m.pname,1) = 'A'

	ot = This.__otarget__

	For nn = 1 To Pcount()-1

		If m.isarray
			this.__apush__( m.ot,m.pname, Evaluate('p'+Transform(m.nn)) )
		Else
			m.ot.&pname..Add( Evaluate('p'+Transform(m.nn)) )
		Endif

	Endfor


*---------------------------------------
Function newitemfor( pname , Key )
*---------------------------------------

	local ot,tvar,onew

	If Type('pName') # 'C'
		Error ' newItemFor() invalid parameter Type '+calledfrom()
	Endif
	
	ot = This.__otarget__

	tvar = Type( 'oT.'+m.pname , 1 )

	Do Case

	Case m.tvar = 'C'

		onew = create('empty')

		If Pcount() = 2
			m.ot.&pname..Add( m.onew, m.key  )
		Else
			m.ot.&pname..Add( m.onew )
		Endif

		Return Createobject('nfset',m.onew )

	Case m.tvar = 'A'

		onew = create('empty')

		this.__apush__( m.ot,m.pname, m.onew )

		Return Createobject('nfset',m.onew)

	Otherwise


		Error m.pname + ' is not a Collection / Array ' 

	Endcase


*-------------------------------------------------------------------------------------------------------
	Procedure newlist( p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13,p14,p15,p16,p17,p18,p19,p20 )
*-------------------------------------------------------------------------------------------------------
	local ot,lp,np
	
	ot = This.__otarget__
	lp = This.__lastproperty__
	Removeproperty(m.ot,m.lp)
	AddProperty(m.ot,m.lp+'(1)')

	If Pcount() > 0
		Dimension This.__acache__( Pcount() )
		For np = 1 To Pcount()
			This.__acache__(m.np) =  Evaluate('p'+Transform(m.np,'@b 99'))
		Endfor
		This.__passitems__ = .T.
	Else
		Dimension This.__acache__(1)
		This.__acache__(1) = .Null.
		This.__passitems__ = .F.
	Endif

	Return .Null.

*-------------------------------
	Procedure Destroy
*-------------------------------
	This.__copycache__()


*------------------------------------------
	Procedure __copycache__
*------------------------------------------

	If !This.__passitems__
		Return
	Endif

	This.__passitems__ = .F.

	local aname
	
	aname = This.__lastproperty__
	Acopy( This.__acache__,This.__otarget__.&aname )
	This.__acache__ = .Null.

*--------------------------------------
	Procedure newcollection(  p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13,p14,p15,p16,p17,p18,p19,p20 )
*--------------------------------------

	Local ocol,nn
	
	ocol = Createobject('collection')

	For nn = 1 To Pcount()

		ocol.Add(  Evaluate('p'+Transform(m.nn,'@b 99') ))

	Endfor

	Return m.ocol


*-----------------------------------------
Function __apush__( o, pname , vvalue )
*-----------------------------------------
local uel

uel = Alen( m.o.&pname )

If !Isnull( m.o.&pname )
	m.uel = m.uel+1
	Dimension m.o.&pname( m.uel )
Endif

m.o.&pname( m.uel ) =  m.vvalue



**********************************************
Enddefine
**********************************************

