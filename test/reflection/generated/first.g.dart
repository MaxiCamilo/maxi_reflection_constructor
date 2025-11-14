//ignore_for_file: unnecessary_const, unnecessary_import, duplicate_import, unused_import

import 'package:maxi_reflection_constructor/maxi_reflection_constructor.dart';
import 'package:maxi_framework/maxi_framework.dart';
import 'package:maxi_reflection/maxi_reflection.dart';
import 'package:maxi_reflection/maxi_reflection_ext.dart';

import '../../classes/first.dart';
import 'package:maxi_framework/maxi_framework.dart';
import 'package:maxi_reflection/maxi_reflection.dart';


//[ENUM] Michis
const michisReflection = ReflectedEnum(
	dartType: Michis,
	anotations: [reflect],
	options: [
		ReflectedEnumOption(anotations: [FixedOration(message: 'El más lindo <3')], value: Michis.oreo),
		ReflectedEnumOption(anotations: [], value: Michis.chichita),
		ReflectedEnumOption(anotations: [], value: Michis.keroncho),
		ReflectedEnumOption(anotations: [], value: Michis.takara),
	],
);
/////////////////////////////////////////////////////////////////////////////////////////



//[CLASS] First
class FirstReflector extends ReflectedClassImplementation<First>{
	FirstReflector({
		required super.manager,
		super.hasBaseConstructor =  true,
		super.anotations = const [reflect],
		super.extendsType,
		super.isConstClass =  false,
		super.isInterface =  false,
		super.packagePrefix = 'test',
		super.traits = const [],
		super.typeName = 'First',
	});
	@override
	Result createNewInstance({ReflectionManager? manager}) {
		return ResultValue(content: First());
	}
	@override
	List<ReflectedField> buildNativeFields({required ReflectionManager manager}) {
		return [
			_buildFirstbestNumberField(manager),_buildFirstidentifierField(manager),_buildFirstnameField(manager),_buildFirstisCoolField(manager)
		];
	}
	@override
	List<ReflectedMethod> buildNativeMethods({required ReflectionManager manager}){
		return [
			_buildFirstwelcomeMessageMethod(manager),_buildFirstMethod(manager),_buildFirstcreateMaxiMethod(manager),_buildFirstcompleteConstructorMethod(manager),_buildFirstcompleteNamedConstructorMethod(manager)
		];
	}
}
//[FIELD] First -> bestNumber
ReflectedFieldInstance<First, int> _buildFirstbestNumberField(ReflectionManager manager){
	final annotations = const [];
	return ReflectedFieldInstance<First, int>(
		anotations: annotations,
		name: 'bestNumber',
		isStatic: true,
		isFinal: true,
		isLate: false,
		reflectedType: ReflectedFlexible(externalAnotations: annotations, manager: manager, realType: int),
		getter: (First? instance) => First.bestNumber,
		setter: (First? instance, int value) => ReflectedField.constSeterError('bestNumber'),
	);
}
/////////////////////////////////////////////////////////////////////////////////////////

//[FIELD] First -> identifier
ReflectedFieldInstance<First, int> _buildFirstidentifierField(ReflectionManager manager){
	final annotations = const [primaryKey];
	return ReflectedFieldInstance<First, int>(
		anotations: annotations,
		name: 'identifier',
		isStatic: false,
		isFinal: false,
		isLate: false,
		reflectedType: ReflectedFlexible(externalAnotations: annotations, manager: manager, realType: int),
		getter: (First? instance) => instance!.identifier,
		setter: (First? instance, int value) => instance!.identifier = value,
	);
}
/////////////////////////////////////////////////////////////////////////////////////////

//[FIELD] First -> name
ReflectedFieldInstance<First, String> _buildFirstnameField(ReflectionManager manager){
	final annotations = const [FixedOration(message: 'Name')];
	return ReflectedFieldInstance<First, String>(
		anotations: annotations,
		name: 'name',
		isStatic: false,
		isFinal: false,
		isLate: false,
		reflectedType: ReflectedFlexible(externalAnotations: annotations, manager: manager, realType: String),
		getter: (First? instance) => instance!.name,
		setter: (First? instance, String value) => instance!.name = value,
	);
}
/////////////////////////////////////////////////////////////////////////////////////////

//[FIELD] First -> isCool
ReflectedFieldInstance<First, bool> _buildFirstisCoolField(ReflectionManager manager){
	final annotations = const [];
	return ReflectedFieldInstance<First, bool>(
		anotations: annotations,
		name: 'isCool',
		isStatic: false,
		isFinal: false,
		isLate: false,
		reflectedType: ReflectedFlexible(externalAnotations: annotations, manager: manager, realType: bool),
		getter: (First? instance) => instance!.isCool,
		setter: (First? instance, bool value) => instance!.isCool = value,
	);
}
/////////////////////////////////////////////////////////////////////////////////////////

//[METHOD] First -> welcomeMessage
ReflectedMethodInstance<First, String> _buildFirstwelcomeMessageMethod(ReflectionManager manager){
	final annotations = const [];
	return ReflectedMethodInstance<First, String>(
		anotations: annotations,
		name: 'welcomeMessage',
		isStatic: true,
		methodType: ReflectedMethodType.method,
		reflectedType: ReflectedFlexible(externalAnotations: annotations, manager: manager, realType: String),
		invoker: (instance, parameters) => First.welcomeMessage(parameters.fixed<String>(0)),
		fixedParameters: [
			ReflectedFixedParameter(
				anotations: const [],
				reflectedType: ReflectedFlexible(externalAnotations: const [], manager: manager, realType: String),
				name: 'name',
				index: 0,
				isOptional: false,
				defaultValue: null ,
			),
		],
		namedParameters: [
		],
	);
}
/////////////////////////////////////////////////////////////////////////////////////////

//[METHOD] First -> 
ReflectedMethodInstance<First, First> _buildFirstMethod(ReflectionManager manager){
	final annotations = const [];
	return ReflectedMethodInstance<First, First>(
		anotations: annotations,
		name: '',
		isStatic: true,
		methodType: ReflectedMethodType.contructor,
		reflectedType: ReflectedFlexible(externalAnotations: annotations, manager: manager, realType: First),
		invoker: (instance, parameters) => First(),
		fixedParameters: [
		],
		namedParameters: [
		],
	);
}
/////////////////////////////////////////////////////////////////////////////////////////

//[METHOD] First -> createMaxi
ReflectedMethodInstance<First, First> _buildFirstcreateMaxiMethod(ReflectionManager manager){
	final annotations = const [];
	return ReflectedMethodInstance<First, First>(
		anotations: annotations,
		name: 'createMaxi',
		isStatic: true,
		methodType: ReflectedMethodType.contructor,
		reflectedType: ReflectedFlexible(externalAnotations: annotations, manager: manager, realType: First),
		invoker: (instance, parameters) => First.createMaxi(),
		fixedParameters: [
		],
		namedParameters: [
		],
	);
}
/////////////////////////////////////////////////////////////////////////////////////////

//[METHOD] First -> completeConstructor
ReflectedMethodInstance<First, First> _buildFirstcompleteConstructorMethod(ReflectionManager manager){
	final annotations = const [];
	return ReflectedMethodInstance<First, First>(
		anotations: annotations,
		name: 'completeConstructor',
		isStatic: true,
		methodType: ReflectedMethodType.contructor,
		reflectedType: ReflectedFlexible(externalAnotations: annotations, manager: manager, realType: First),
		invoker: (instance, parameters) => First.completeConstructor(parameters.fixed<int>(0),parameters.fixed<String>(1),parameters.optionalFixed<bool>(location: 2, predetermined: false)),
		fixedParameters: [
			ReflectedFixedParameter(
				anotations: const [],
				reflectedType: ReflectedFlexible(externalAnotations: const [], manager: manager, realType: int),
				name: 'id',
				index: 0,
				isOptional: false,
				defaultValue: null ,
			),
			ReflectedFixedParameter(
				anotations: const [],
				reflectedType: ReflectedFlexible(externalAnotations: const [], manager: manager, realType: String),
				name: 'name',
				index: 1,
				isOptional: false,
				defaultValue: null ,
			),
			ReflectedFixedParameter(
				anotations: const [],
				reflectedType: ReflectedFlexible(externalAnotations: const [], manager: manager, realType: bool),
				name: 'cool',
				index: 2,
				isOptional: true,
				defaultValue: false ,
			),
		],
		namedParameters: [
		],
	);
}
/////////////////////////////////////////////////////////////////////////////////////////

//[METHOD] First -> completeNamedConstructor
ReflectedMethodInstance<First, First> _buildFirstcompleteNamedConstructorMethod(ReflectionManager manager){
	final annotations = const [];
	return ReflectedMethodInstance<First, First>(
		anotations: annotations,
		name: 'completeNamedConstructor',
		isStatic: true,
		methodType: ReflectedMethodType.contructor,
		reflectedType: ReflectedFlexible(externalAnotations: annotations, manager: manager, realType: First),
		invoker: (instance, parameters) => First.completeNamedConstructor(id: parameters.optionalNamed<int>(name: 'id', predetermined: 0),name: parameters.named<String>('name'),cool: parameters.optionalNamed<bool>(name: 'cool', predetermined: false)),
		fixedParameters: [
		],
		namedParameters: [
			ReflectedNamedParameter(
				anotations: const [],
				reflectedType: ReflectedFlexible(externalAnotations: const [], manager: manager, realType: int),
				name: 'id',
				isRequired: false,
				defaultValue: 0,
			),
			ReflectedNamedParameter(
				anotations: const [],
				reflectedType: ReflectedFlexible(externalAnotations: const [], manager: manager, realType: String),
				name: 'name',
				isRequired: true,
				defaultValue: null,
			),
			ReflectedNamedParameter(
				anotations: const [],
				reflectedType: ReflectedFlexible(externalAnotations: const [], manager: manager, realType: bool),
				name: 'cool',
				isRequired: false,
				defaultValue: false,
			),
		],
	);
}
/////////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////////////////

