package ic.doc.strategy;

import java.util.Iterator;

public class NumbersSequence implements Iterable<Integer> {
    private SequenceGenerator generator;

    public NumbersSequence(SequenceGenerator generator) {
       this.generator = generator;
    }

    public int term(int i) {
        if (i < 0) {
            throw new IllegalArgumentException("Not defined for indices < 0");
        }
        return this.generator.ithPositiveTerm(i);
    }

    public Iterator<Integer> iterator() {
        return new SequenceIterator();
    }

    private class SequenceIterator implements Iterator<Integer> {

        private int index = 0;

        @Override
        public boolean hasNext() {
            return true;
        }

        @Override
        public Integer next() {
            return term(index++);
        }

        @Override
        public void remove() {
            throw new UnsupportedOperationException("remove is not implemented");
        }
    }
}
