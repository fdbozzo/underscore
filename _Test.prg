Public omypc && check later on your debugger

*************************************************************
* using _ instead of addproperty() allows you add 
* arrays and create deep structures at once. 
* even copy arrays to object property 
*************************************************************

 adir(filesList)
 ofiles = create('empty')
 _( m.oFiles,"one.two.myFiles",@fileslist )
 ? oFiles.one.two.myFiles(1,1)

 ofiles2 = create('empty')
 _( oFiles2, "thesame.in.other.node", m.oFiles, "one.two.myFiles" )
 ? oFiles2.thesame.in.other.node(1,1)


*****************************************************
* adding properties to existing objects:
*****************************************************

omypc = Createobject('empty')

With _( omypc )  && simply pass object you want to modify, any referenced property will be added to passed object if does not exist:

	.madeby = 'Marco Plaza, 2018 - nfTools'
	.manufacturer = 'custom'
	.baseprice = 699
	.casetype  = 'ATX'
	.modelname = 'Ryzen Performance Plus'

	With _( .cpu )   && cpu will be a new object for oMyPc - check we pass ".cpu"  ( dot cpu ) because it's inside with - endwith
		.processorcount = 6
		.brand = 'AMD'
		.model = 'Ryzen 7'
		.clockspeed = 4.3
		.processorcount = 8
	Endwith


	With _(.motherboard)

		.manufacturer = 'Asus'
		.model = 'Prime B350-Plus AMD'
		.formfactor = 'ATX'
		.cpusocket = 'AM4'

		.power = .newList('CPU','CASE1','CASE2','CASE3')  && creating a list with 4 items

		.SPECS = .newCollection()
		
		.specs.add('First Item with key','testKey1')  && normal collection add()
		
		with .newItem('specs','memory')
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

	.storage = .newList()
	
	with .newItem( 'storage' )  && adding objects to list
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

*-----------------------------------------------

public oCust

oCust = createObject('empty')

with _( m.oCust ,'.info.address.billing.phone')

	.number = 2358811
	
endwith

? 'm.oCust.info.address.billing.phone.number:'
?? m.oCust.info.address.billing.phone.number



