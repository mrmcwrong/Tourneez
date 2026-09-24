import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:tourneez/domain/match_odds.dart';

void main() {
  group('computeMatchOdds', () {
    test('equal powers are roughly even', () {
      final odds = computeMatchOdds(homePower: 50, awayPower: 50);
      expect(odds.homeWin, closeTo(odds.awayWin, 0.001));
      expect(odds.draw, greaterThan(0.2));
      expect(odds.homeWin + odds.draw + odds.awayWin, closeTo(1.0, 0.001));
    });

    test('stronger home is favored', () {
      final odds = computeMatchOdds(homePower: 90, awayPower: 30);
      expect(odds.homeWin, greaterThan(odds.awayWin));
      expect(odds.homeWin, greaterThan(0.55));
    });

    test('bracket mode has no draws', () {
      final odds = computeMatchOdds(
        homePower: 60,
        awayPower: 40,
        allowDraw: false,
      );
      expect(odds.draw, 0);
      expect(odds.homeWin + odds.awayWin, closeTo(1.0, 0.001));
    });
  });

  group('sampleScore', () {
    test('respects no-draw for brackets', () {
      final rng = Random(42);
      for (var i = 0; i < 30; i++) {
        final score = sampleScore(
          homePower: 55,
          awayPower: 45,
          allowDraw: false,
          random: rng,
        );
        expect(score.home == score.away, isFalse);
      }
    });

    test('can produce draws when allowed', () {
      final rng = Random(7);
      var sawDraw = false;
      for (var i = 0; i < 80; i++) {
        final score = sampleScore(
          homePower: 50,
          awayPower: 50,
          allowDraw: true,
          random: rng,
        );
        if (score.home == score.away) sawDraw = true;
      }
      expect(sawDraw, isTrue);
    });
  });
}
