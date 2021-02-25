**************************************************************
* Author: Marco Plaza, 2018,2021
* @nfoxProject, http://www.noVfp.com
* nfTools https://github.com/nfTools
* ver 1.3.1
****************************************************************************************
* This program is part of nfTools, a support library for nFox.
* You are free to use, modify and include it in your compiled projects.
****************************************************************************************
* Parameters __otarget__[, cnewobjectpath[, newPropertyValue[, cArrayPath]]]
*
* usage ( see _test.prg )
*
*
* with _( object , [ cNewObjectpath ] )  && Object = base object you wish to work with; cNewObjectpath will add child objects to Object as parents for <newObjectpropertyName>
*
*	.property1 = any valid vfp expression
*
*	.property2 = any valid vfp expression
*
*	with _( .<newObjectPropertyName> [,cNewObjectpath] )  && adds a new dynamic object to current object; cNewObjectpath will create child objects of parent Object as parents for <newObjectpropertyName>
*		.newObjProperty1 = ...
*		.newObjProperty2 = ...
*
*	endwith
*
*	 .myArray = .acopy( @arraySource )
*
*	 .myList = .newList( [ Item1,Item2,... Item20 ] ) && creates a one dimension array, optional items to add
*
*	 .additems(  keyless collection name | array name , item1 [,item2,.. item20 ]) && adds multiple items to array/ keyless collection
*
*	 with .newItem( collection name | array name  [, collectionItemkey] ) && construct and add objects to array or collection with optional key
*
*		.itemproperty1 = value
*
*		.itemproperty2 = value
*
*	 endwith
*
* endwith
*
* using _ instead of addproperty() allows you add arrays
* and create deep strctures at once:
* to pass arrays by reference, or object,arrayPath
*
* adir(filesList)
* ofiles = create('empty')
* _( m.oFiles,"one.two.myFiles",@fileslist )
* ? oFiles.one.two.myFiles(1,1)
*
* ofiles2 = create('empty')
* _( oFiles, "thesame.in.other.node", m.oFiles, "one.two.myFiles" )
* ? oFiles.thesame.in.other.node(1,1)
*
**************************************************************
Lparameters __otarget__, cnewobjectpath, newpropertyvalue, carraypath

Local emessage,oobserver


Try

	emessage = ''
	oobserver = .Null.
	carraypath = Evl(m.carraypath,'')


	If Vartype(__otarget__) # 'O'
		Error 'nfTools: Invalid parameter type - must supply an object '+Chr(13)
	Endif

	If Vartype(m.cnewobjectpath) = 'C'


		Do Case
		Case Pcount() = 2
			If Right(m.cnewobjectpath,1) = ')'
				newpropertyvalue = .Null. && arrays can't have object as default value.
			Else
				newpropertyvalue = Createobject('empty')
			Endif


		Case Pcount() = 4

			If Not aPathIsValid( m.newpropertyvalue, @carraypath )
				Error 'invalid object.arrayPath '
			Endif

		Endcase

		createchildfor( @__otarget__ , m.cnewobjectpath, @newpropertyvalue, m.carraypath )

	Endif

	If Pcount() < 3
		oobserver = Createobject('nfset', m.__otarget__  )
	Else
		oobserver = .T.
	Endif

Catch To oerr

	emessage = nf_errorh( oerr)

Endtry


If !Empty(m.emessage)
	Error m.emessage
	Return .Null.
Else
	Return m.oobserver
Endif

******************************************
Define Class nfset As Custom
******************************************
	__otarget__ = .F.
	__lastproperty__ = ''
	__passitems__ = .F.
	Dimension __atemp__(1)


*----------------------------------------
	Procedure Init( __otarget__ )
*----------------------------------------

	This.__otarget__ = m.__otarget__


*---------------------------------------------
	Procedure this_access( pname As String )
*---------------------------------------------

	If Inlist(Lower(m.pname),;
			'additems',;
			'newcollection',;
			'newitem',;
			'newlist',;
			'acopy',;
			'__apush__',;
			'__copytemp__',;
			'__otarget__',;
			'__lastproperty__',;
			'__atemp__',;
			'__passitems__',;
			'__newobject__ ';
			)

		Return This

	Endif

	This.__copytemp__()

	This.__lastproperty__ = m.pname

	If !Pemstatus(This.__otarget__,m.pname,5)

		Local fail
		Try
			AddProperty( This.__otarget__, m.pname, Createobject('empty') )
			fail = .F.
		Catch
			fail = .T.
		Endtry
		If m.fail
			Error 'Incorrect property name "'+m.pname+'"'
		Endif

	Endif

	Return This.__otarget__

*---------------------------------------
	Function additems( pname, p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13,p14,p15,p16,p17,p18,p19,p20 )
*---------------------------------------

	Local ot,nn,isarray

	If Not Type( 'this.__oTarget__.'+m.pname,1) $ 'C,A'
		Error  pname + ' is not a Collection / Array '
	Endif

	isarray = Type( 'this.__oTarget__.'+m.pname,1) = 'A'

	ot = This.__otarget__

	For nn = 1 To Pcount()-1

		If m.isarray
			This.__apush__( m.ot,m.pname, Evaluate('p'+Transform(m.nn)) )
		Else
			m.ot.&pname..Add( Evaluate('p'+Transform(m.nn)) )
		Endif

	Endfor


*-----------------------------------------
	Function NewItem( pname , Key, Value )
*-----------------------------------------


	If Type('pName') # 'C'
		Error ' newItem(): invalid collection / array name '
	Endif

	ot = This.__otarget__

	tvar = Type( 'oT.'+m.pname , 1 )

	If Pcount() # 3
		NewItem = Create('empty')
	Else
		NewItem = m.value
	Endif

	Do Case

	Case m.tvar = 'C'

		If Pcount() > 1
			m.ot.&pname..Add( m.NewItem, m.key  )
		Else
			m.ot.&pname..Add( m.NewItem )
		Endif

	Case m.tvar = 'A'

		This.__apush__( m.ot,m.pname, m.NewItem )

	Otherwise

		Error m.pname + ' is not a Collection / Array '
		Return .Null.

	Endcase

	If Vartype(m.NewItem) = 'O'
		Return Createobject('nfset',m.NewItem)
	Else
		Return .T.
	Endif


*-------------------------------------------------------------------------------------------------------
	Procedure newlist( p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13,p14,p15,p16,p17,p18,p19,p20 )
*-------------------------------------------------------------------------------------------------------
	Local ot,lp,np

	ot = This.__otarget__
	lp = This.__lastproperty__
	Removeproperty(m.ot,m.lp)
	AddProperty(m.ot,m.lp+'(1)')

	If Pcount() > 0

		Dimension This.__atemp__( Pcount() )
		For np = 1 To Pcount()
			This.__atemp__(m.np) =  Evaluate('p'+Transform(m.np))
		Endfor

		This.__passitems__ = .T.

	Else

		Dimension This.__atemp__(1)
		This.__atemp__(1) = .Null.
		This.__passitems__ = .F.

	Endif

	Return .Null.


*-------------------------------------------------------------------------------------------------------
	Procedure Acopy( p1 )
*-------------------------------------------------------------------------------------------------------
	Local ot,lp,np,fail

	ot = This.__otarget__
	lp = This.__lastproperty__
	Removeproperty(m.ot,m.lp)

	Try
		AddProperty(m.ot,m.lp+'(1)')
		fail = .F.
	Catch
		fail = .T.
	Endtry

	If m.fail
		Error 'Invalid array name: "'+m.lp+'"'
		Return .Null.
	Endif

	If Alen(p1,2) = 0
		Dimension This.__atemp__(1)
	Else
		Dimension This.__atemp__(Alen(p1,1),Alen(p1,2))
	Endif

	Acopy(p1,This.__atemp__)

	This.__passitems__ = .T.

	Return .Null.

*-------------------------------
	Procedure Destroy
*-------------------------------
	This.__copytemp__()


*------------------------------------------
	Procedure __copytemp__
*------------------------------------------

	If !This.__passitems__
		Return
	Endif

	This.__passitems__ = .F.

	Local aname

	aname = This.__lastproperty__
	Acopy( This.__atemp__,This.__otarget__.&aname )
	This.__atemp__ = .Null.



*-----------------------------------------
	Function __apush__( o, pname , vvalue )
*-----------------------------------------
	Local uel

	uel = Alen( m.o.&pname )

	If !Isnull( m.o.&pname )
		m.uel = m.uel+1
		Dimension m.o.&pname( m.uel )
	Endif

	m.o.&pname( m.uel ) =  m.vvalue

*--------------------------------------
	Procedure newcollection(  p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13,p14,p15,p16,p17,p18,p19,p20 )
*--------------------------------------

	Local ocol,nn

	ocol = Createobject('collection')

	For nn = 1 To Pcount()

		ocol.Add(  Evaluate('p'+Transform(m.nn) ))

	Endfor

	Return m.ocol


**********************************************
Enddefine
**********************************************

*------------------------------------------------------------------------
Function createchildfor( thiso , cChildPath , vnewvalue , carraypath )
*------------------------------------------------------------------------

Local nLevels
Local thispath
Local thisChild
Local vtype
Local islastChild
Local nlevel
Private oo

cChildPath =  Alltrim( m.cChildPath,1,'.',' ' )

nLevels = Alines(oo,m.cChildPath,.F.,'.')

thispath = ''

For nlevel = 1 To m.nLevels

	thisChild  = m.oo(m.nlevel)

	vtype = Type( 'm.thiso.'+m.thisChild )

	thispath = m.thispath+'.'+m.thisChild

	islastChild = nlevel = m.nLevels

	Try

		Do Case

		Case !m.islastChild  And m.vtype # 'U' And m.vtype # 'O'
			Error m.thispath+' is not an object'

		Case !m.islastChild  And m.vtype = 'U'

			AddProperty( m.thiso , m.thisChild , Createobject('empty') )

		Case m.islastChild

			Removeproperty(m.thiso,m.thisChild)


			Do Case
			Case aPathIsValid( m.vnewvalue , @carraypath )

				AddProperty(m.thiso,m.thisChild+'(1)',.Null.)
				Acopy(m.vnewvalue.&carraypath,m.thiso.&thisChild)

			Case Type("m.vNewValue",1) = "A"
				AddProperty( m.thiso , m.thisChild+'(1)',.Null. )
				Acopy(m.vnewvalue, m.thiso.&thisChild)

			Other
				AddProperty( m.thiso , m.thisChild, m.vnewvalue )

			Endcase


		Endcase

	Catch

		Error 'incorrect property Name or value for "'+m.cChildPath+'"'

	Endtry

	thiso  = m.thiso.&thisChild

Endfor

*--------------------------------------------
Function aPathIsValid( oSrc,cpath )
*--------------------------------------------
Local isValid

cpath = Ltrim(m.cpath,1,'.')

isValid = Vartype(m.oSrc) = 'O' And Vartype(m.cpath) = 'C' And !Empty(m.cpath) And Type('m.oSrc.'+m.cpath,1) = 'A'

Return m.isValid

