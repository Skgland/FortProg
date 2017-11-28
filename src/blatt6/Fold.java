package blatt6;

import java.util.List;
import java.util.function.BiFunction;

public class Fold {

	public static <T, S> T foldr(BiFunction<S, T, T> funktion, T leer, List<S> alist) {
		if (alist != null && !alist.isEmpty()) {
			S head = alist.get(0);
			alist.remove(0);
			return funktion.apply(head, foldr(funktion, leer, alist));
		}
		return leer;
	}

	public static <T, S> T foldl(BiFunction<T, S, T> funktion, T leer, List<S> alist) {
		if (alist != null && !alist.isEmpty()) {
			S head = alist.get(0);
			alist.remove(0);
			return foldl(funktion,funktion.apply(leer, head),alist);
		}
		return leer;

	}

}