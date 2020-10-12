Class {
	#name : #MOAngularModelWriter,
	#superclass : #Object,
	#instVars : [
		'model'
	],
	#category : #'Moxing-CodeWritingTypescript'
}

{ #category : #'as yet unclassified' }
MOAngularModelWriter >> typeReferenceFor: aType [
	| destinationTypeName |
	destinationTypeName := 
	{
	('dbLong' -> 'bigint').
	('dbDate' -> 'Date').
	('dbCurrency' -> 'number').
	('dbText' -> 'string').
	('dbMemo' -> 'string').
	} asDictionary at: aType.
	^ MOTypescriptTypeReference new
		name: destinationTypeName;
		yourself
]

{ #category : #'as yet unclassified' }
MOAngularModelWriter >> visitColumn: aMDColumn [
	model
		addProperty:
			(MOTypescriptVariable new
				name: aMDColumn compilableIdentifier;
				type: (self typeReferenceFor: aMDColumn type);
				yourself)
]

{ #category : #'as yet unclassified' }
MOAngularModelWriter >> visitDataBinding: aMODataBindingAttribute [
	aMODataBindingAttribute binding entity accept: self
]

{ #category : #'as yet unclassified' }
MOAngularModelWriter >> visitRelationalView: aMDRelationalView [ 
	model := MOTypescriptClass new.
	model name: aMDRelationalView compilableTypeIdentifier .
	aMDRelationalView elements do: [ : e | e accept: self ]
]

{ #category : #writing }
MOAngularModelWriter >> writeModelFor: aMDDataBinding [
	aMDDataBinding accept: self.
	^ MOAngularProtoClass new
		setClass: model;
		yourself
]