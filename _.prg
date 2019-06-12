**************************************************************
* Author: Marco Plaza, 2018
* @nfoxProject, http://www.noVfp.com
* nfTools https://github.com/nfTools
* ver 1.1.0
****************************************************************************************
* This program is part of nfTools, a support library for nFox.
* You are free to use, modify and include it in your compiled projects.
****************************************************************************************
* Parameters __otarget__[, cnewobjectparentpath[, newPropertyValue[, cArrayPath]]]
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
* _( oFiles2, "thesame.in.other.node", m.oFiles, "one.two.myFiles" )
* ? oFiles2.thesame.in.other.node(1,1)
*
**************************************************************
Parameters __otarget__, cnewobjectparentpath, newPropertyValue, cArrayPath

Local emessage,oObserver


Try

	emessage = ''
	oObserver = .Null.

	If Vartype(__otarget__) # 'O'
		Error 'nfTools: Invalid parameter type - must supply an object '+Chr(13)
	Endif

	If Vartype(m.cnewobjectparentpath) = 'C'

		If Pcount() = 2
			newPropertyValue = Createobject('empty')
		Endif

		If Pcount() = 4
			
			cArrayPath = ltrim(m.cArrayPath,1,'.')
			
			If aPathisValid( m.newPropertyValue, m.cArrayPath) 
				cArrayPath = '.'+m.cArrayPath
			else
				Error 'invalid object.arrayPath '
			Endif
		Else
			cArrayPath = ''
		Endif

		Do createchildsfor With  __otarget__ , m.cnewobjectparentpath, newPropertyValue,cArrayPath

	Endif

	oObserver = Createobject('nfset', m.__otarget__  )


Catch To oerr

	emessage = oerr.message()

Endtry


If !Empty(m.emessage)
	Error m.emessage
	Return .Null. && prevent retry/ignore
Else
	Return m.oObserver
Endif

******************************************
Define Class nfset As Custom
******************************************
	__otarget__ = .F.
	__lastproperty__ = ''
	__passitems__ = .F.
	Dimension __atemp__(1)


*------------------------------------------
	Procedure Error( nerror, cmethod, nline )
*------------------------------------------
	If m.nerror # 1098
		Error 'Underscore error '+Transform(m.nerror)+' Line '+Transform(m.nline)+': '+Message()
	Else
		Error 'Underscore: '+Message()
	Endif

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
			'newitemfor',;
			'newlist',;
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

		AddProperty( This.__otarget__, m.pname, Createobject('empty') )

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


*---------------------------------------
	Function newitemfor( pname , Key )
*---------------------------------------

	Local ot,tvar,onew

	If Type('pName') # 'C'
		Error ' newItemFor() invalid parameter Type '
	Endif

	ot = This.__otarget__

	tvar = Type( 'oT.'+m.pname , 1 )

	Do Case

	Case m.tvar = 'C'

		onew = Create('empty')

		If Pcount() = 2
			m.ot.&pname..Add( m.onew, m.key  )
		Else
			m.ot.&pname..Add( m.onew )
		Endif

		Return Createobject( 'nfset' ,m.onew  )

	Case m.tvar = 'A'

		onew = Create('empty')

		This.__apush__( m.ot,m.pname, m.onew )

		Return Createobject('nfset',m.onew)

	Otherwise


		Error m.pname + ' is not a Collection / Array '

	Endcase


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

*--------------------------------------
	Procedure newcollection(  p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13,p14,p15,p16,p17,p18,p19,p20 )
*--------------------------------------

	Local ocol,nn

	ocol = Createobject('collection')

	For nn = 1 To Pcount()

		ocol.Add(  Evaluate('p'+Transform(m.nn) ))

	Endfor

	Return m.ocol


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


**********************************************
Enddefine
**********************************************

*------------------------------------------------------------------------
Function createchildsfor( THISO , cchildspath , vNewvalue , cArrayPath )
*------------------------------------------------------------------------

private all

cchildspath =  Alltrim( m.cchildspath,1,'.',' ' )

nLevels = Alines(oo,m.cchildspath,.F.,'.')

thispath = ''

For nlevel = 1 To m.nLevels

	thisChild  = m.oo(m.nlevel)

	vtype = Type( 'm.thiso.'+m.thisChild )

	thispath = m.thispath+'.'+m.thisChild

	islastChild = nlevel = m.nLevels

	If m.islastChild  And m.vtype # 'U'
		Removeproperty(m.THISO,m.thisChild)
		vtype = 'U'
	Endif

	Do Case

	Case m.vtype = 'U'

		Try

			If !m.islastChild

				AddProperty( m.THISO , m.thisChild , Createobject('empty') )

			Else

				If Type("m.vNewValue&cArraypath",1) = 'A'

					AddProperty(m.THISO,m.thisChild+'(1)',.Null.)
					Acopy(vNewvalue&cArrayPath,m.THISO.&thisChild)

				Else

					AddProperty( m.THISO , m.thisChild , m.vNewvalue )

				Endif

			Endif


		Catch

			Error 'incorrect property Name: "'+m.thisChild+'" in '+m.thispath

		Endtry

	Case !m.islastChild And  m.vtype # 'O'
		Error m.thispath+' is not an object'

	Endcase

	THISO  = m.THISO.&thisChild

Endfor


