import 'package:maxi_reflection/maxi_reflection.dart';
import 'generated/first.g.dart';

class TestReflectors implements ReflectionBook{
	const TestReflectors();
	@override
	String get prefixName => 'test';
	@override
	List<ReflectedEnum> buildEnums({required ReflectionManager manager}) => const [michisReflection];
	@override
	List<ReflectedClass> buildClassReflectors({required ReflectionManager manager}) {
		return [
			 FirstReflector(manager: manager)
		];
	}
	@override
	List<ReflectedType> buildOtherReflectors({required ReflectionManager manager}) => const [];
}
