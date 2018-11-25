  
## "underscore" \_() 

********************************

Construct &amp; Model complex Visual Foxpro Objects*  adding properties, arrays and collections the easy way.  
Just make \_.prg available in your search path and start using it. 
<a  href='#en'> Reference </a>


Construya y Modele objetos complejos de Visual Foxpro agregando propiedades, listas y colecciones de manera fácil.  
Simplemente haga que \_.Prg esté disponible en la ruta de búsqueda y comience a usarlo.  
<a href='#es'> Referencia <a>

**********************************
<a id='en'></a>
## Usage: ( see <a href='https://github.com/nftools/underscore/blob/master/_Test.prg'> \_test.prg </a>)

```

*Object = base object you wish to work with
*Optional cNewObjectParentPath will add child objects to Object and set scope to the last child"

 with _( m.object , [ cNewObjectParentPath ] )  

* any previously unexistent property will be created on the fly
* same as addproperty( object, 'property1', any valid vfp expression )

	.property1 = any valid vfp expression
	.property2 = any valid vfp expression

*adds a &ltnewObjectName&gt dynamic object to current object in scope of with .. endwith
*Optional cNewObjectParentPath will create child objects of parent Object as parents for \<newObjectpropertyName\>

	with _( .newObjectName [,cNewObjectParentPath] )  
		.newObjProperty1 =  any valid vfp expression
		.newObjProperty2 =  any valid vfp expression

	endwith

*create a quick keyless collection
*optionally you pass up to 20 items at once as parameters

	 .myCollection = .newCollection( [Item1,Item2,... Item20 ]) 

*create a quick one dimensional array
*optionally you can pass up to 20 items at once as parameters

	 .myList = .newList( [ Item1,Item2,... Item20 ] ) 

*quickly add up to 20 items to array/ keyless collection:

	 .additems( "keylessCollectionName │ arrayName" , item1,item2,.. item20 ) 

*add a dynamic object to array or collection & optional collection item key

	 with .newItemFor("< collectionName │ arrayName >" [, collectionItemkey] )

		.itemproperty1 = any valid vfp expression
		.itemproperty2 = any valid vfp expression

	 endwith

 endwith
```



**************************************************************

<a id='es'></a>
##  Uso ( ver <a href='https://github.com/nftools/underscore/blob/master/_Test.prg'> \_test.prg </a>)

```

* Object = el objeto base con el que desea trabajar
* Opcional: cNewObjectParentPath agregará objetos secundarios a Objeto y establecerá el alcance al último objeto"

 with _( m.object , [ cNewObjectParentPath ] )  

* cualquier propiedad previamente inexistente se creará al vuelo 
* igual que hacer " addproperty(objeto, 'property1', cualquier expresión vfp válida) "

	.property1 = any valid vfp expression
	.property2 = any valid vfp expression

* agrega un objeto dinámico \<newObjectName\> al objeto actual y lo coloca como alcance para with .. endwith \>
* Opcional: cNewObjectParentPath creará objetos secundarios del objeto primario y establecerá el alcance al último objeto 

	with _( .newObjectName [,cNewObjectParentPath] )  
		.newObjProperty1 =  any valid vfp expression
		.newObjProperty2 =  any valid vfp expression

	endwith 
	
* crea una colección rápida sin llave  
* opcionalmente puede pasar hasta 20 elementos a la vez como parámetros para ser añadidos a la colección

	 .myCollection = .newCollection( [Item1,Item2,... Item20 ]) 

* crea un array unidimensional ( lista ) rápida  
* opcionalmente puede pasar hasta 20 elementos a la vez como parámetros para ser añadidos a la lista 

	 .myList = .newList( [ Item1,Item2,... Item20 ] ) 

* agrega rápidamente hasta 20 elementos a la colección sin llave o lista: 

	 .additems( "keylessCollectionName │ arrayName" , item1,item2,.. item20 ) 

* agregar un objeto dinámico a la lista o colección y opcionalmente una clave del elemento de la colección 

	 with .newItemFor("< collectionName │ arrayName >" [, collectionItemkey] )

		.itemproperty1 = any valid vfp expression
		.itemproperty2 = any valid vfp expression

	 endwith

 endwith
```



**************************************************************
