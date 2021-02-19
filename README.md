  
## "underscore" \_() 

********************************

Construct &amp; Model complex Visual Foxpro Objects*  adding properties, arrays and collections the easy way.  
Just make \_.prg available in your search path and start using it.  
<a href='#en'> Quick Guide.. </a>

Construya y Modele objetos complejos de Visual Foxpro agregando propiedades, listas y colecciones de manera fácil.  
Simplemente haga que \_.Prg esté disponible en la ruta de búsqueda y comience a usarlo.  
<a href='#es'> Guia Rápida.. <a>

**********************************
<a id='en'></a>
## Usage: ( see <a href='https://github.com/nftools/underscore/blob/master/_Test.prg'> \_test.prg </a>)

```
*****************************************************
* adding properties to existing objects:
*****************************************************

public oCust, oMyPc

oCust = createObject('empty')

with _( m.oCust ,'.info.address.billing.phone')

	.number = 2358811
	
endwith

? 'm.oCust.info.address.billing.phone.number:'
?? m.oCust.info.address.billing.phone.number


omypc = Createobject('empty')

With _( omypc )  && simply pass object you want to modify, any non-existent property will be added if does not exist:

	.madeby = 'Marco Plaza, 2018 - nfTools'
	.manufacturer = 'custom'
	.baseprice = 699
	.casetype  = 'ATX'
	.modelname = 'Ryzen Performance Plus'

	With _( .cpu )   &&  ( oMyPc.cpu  ) 
		.processorcount = 6
		.brand = 'AMD'
		.model = 'Ryzen 7'
		.clockspeed = 4.3
		.processorcount = 8
	Endwith


	With _(.motherboard) && ( oMypc.motherboard )

		.manufacturer = 'Asus'
		.model = 'Prime B350-Plus AMD'
		.formfactor = 'ATX'
		.cpusocket = 'AM4'

		.power = .newList('CPU','CASE1','CASE2','CASE3')  && creating a list with 4 items

		.SPECS = .newCollection()
		
		.specs.add('First Item with key','testKey1')  && normal collection add()
		
		with .newItem('specs','memory') && oMypc.motherboard.specs
			.type = 'DDR4'
			.MAXSIZE = '64GB'
			.slots = 4
		endwith
		
		with .newItem('specs','usb')
			.internal = '3 @ PCIe 3.0 x2'
			.front = 'x1 Type-C'
			.rear  = 'x2 Type-A'
		endwith
		

	Endwith

	.storage = .newList() && simple one dimension array
	
	with .newItem( 'storage' )  && adding objects to storage list
		.manufacturer = 'Samsung'
		.model = '960 evo Series'
		.Type = 'internal'
		.connectivity = 'PCIe NVMe M.2'
		.capacity = '250gb'
	Endwith

	with .newItem( 'storage' )
		.manufacturer = 'Seagate'
		.model = 'Barracuda ST3000DM008'
		.Type = 'Internal'
		.formfactor = 3.5
		.capacity = '3tb'
		.connectivity = 'Sata 6.0'
		.rotationspeed = 7200
	Endwith


endwith

? "oMypc.motherboard.power[1]:"
?? oMypc.motherboard.power[1]

? "omypc.motherboard.specs('memory').maxsize:"
?? omypc.motherboard.specs('memory').maxsize

? "omypc.motherboard.specs('usb').internal:"
?? omypc.motherboard.specs('usb').internal


*************************************************************
* arrays and create deep structures at once. 
* copy arrays to object property 
*************************************************************

 adir(filesList)
 ofiles = create('empty')
 _( m.oFiles,"one.two.myFiles",@fileslist )
 ? oFiles.one.two.myFiles(1,1)

 ofiles2 = create('empty')
 _( oFiles2, "thesame.in.other.node", m.oFiles, "one.two.myFiles" )
 ? oFiles2.thesame.in.other.node(1,1)


```



**************************************************************
