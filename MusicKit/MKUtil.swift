//  Copyright (c) 2015 Ben Guo. All rights reserved.

import Foundation

public enum MKUtil {
    /// Returns the nth inversion of the given sorted array of semitone indices
    static func invert(_ semitoneIndices: [Float], n: UInt) -> [Float] {
        let count = semitoneIndices.count
        let modN = Int(n) % count
        var semitones = semitoneIndices
        for _ in 0..<modN {
            let next = semitones[0] + 12
            semitones = Array(semitones.dropFirst()) + [next]
        }
        return semitones
    }

    /// Transforms an array of semitone indices so that the first index is zero
    static func zero(_ semitoneIndices: [Float]) -> [Float] {
        return semitoneIndices.map { $0 - semitoneIndices[0] }
    }

    /// Collapses an array of semitone indices to within an octave
    static func collapse(_ semitoneIndices: [Float]) -> [Float] {
        let count = semitoneIndices.count
        if count < 1 { return semitoneIndices }
        let first = semitoneIndices[0]
        var newIndices = [first]
        for i in 1..<count {
            var newIndex = semitoneIndices[i]
            while newIndex - first > 12 {
                newIndex -= 12
            }
            newIndices = newIndices + [newIndex]
        }
        return newIndices.sorted()
    }

    /// Converts an array of intervals to semitone indices
    /// e.g. [4, 3] -> [0, 4, 7]
    public static func semitoneIndices(_ intervals: [Float]) -> [Float] {
        return [0] + intervals.scan(0) { $0 + $1 }
    }

    /// Converts an array of semitone indices to intervals
    /// e.g. [0, 4, 7] -> [4, 3]
    public static func intervals(_ semitoneIndices: [Float]) -> [Float] {
        return semitoneIndices.tuples.map { $1 - $0 }
    }
}


extension Collection where Iterator.Element : Comparable, Index == Int {

    /// Returns the insertion point for `pitch` in the collection of `pitches`.
    ///
    /// If `pitch` exists at least once in `pitches`, the returned index will point to the
    /// first instance of `pitch`. Otherwise, it will point to the location where `pitch`
    /// could be inserted, keeping `pitchSet` in order.
    ///
    /// :returns: An index in the range `0...count(pitches)` where `pitch` can be inserted.
    func insertionIndex(_ element: Iterator.Element) -> Index {
        if self.isEmpty {
            return 0
        }

        var (low, high) = (0, self.endIndex - 1)
        var mid = 0

        while low < high {
            mid = (high - low) / 2 + low
            if self[mid] < element {
                low = mid + 1
            } else {
                high = mid
            }
        }

        if self[low] >= element {
            return low
        }
        
        return self.endIndex
    }
}


