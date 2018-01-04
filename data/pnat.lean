/-
Copyright (c) 2017 Microsoft Corporation. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Author: Mario Carneiro
-/

def pnat := {n : ℕ // n > 0}
notation `ℕ+` := pnat

instance coe_pnat_nat : has_coe ℕ+ ℕ := ⟨subtype.val⟩

meta def exact_dec_trivial : tactic unit := `[exact dec_trivial]

namespace nat

def to_pnat (n : ℕ) (h : n > 0 . exact_dec_trivial) : ℕ+ := ⟨n, h⟩

def succ_pnat (n : ℕ) : ℕ+ := ⟨succ n, succ_pos n⟩

@[simp] theorem succ_pnat_coe (n : ℕ) : (succ_pnat n : ℕ) = succ n := rfl

def to_pnat' (n : ℕ) : ℕ+ := succ_pnat (pred n)

end nat

instance coe_nat_pnat : has_coe ℕ ℕ+ := ⟨nat.to_pnat'⟩

namespace pnat

open nat
@[simp] theorem pos (n : ℕ+) : (n : ℕ) > 0 := n.2

theorem eq {m n : ℕ+} : (m : ℕ) = n → m = n := subtype.eq

@[simp] theorem mk_coe (n h) : ((⟨n, h⟩ : ℕ+) : ℕ) = n := rfl

instance : has_add ℕ+ := ⟨λ m n, ⟨m + n, add_pos m.2 n.2⟩⟩

@[simp] theorem add_coe (m n : ℕ+) : ((m + n : ℕ+) : ℕ) = m + n := rfl

@[simp] theorem ne_zero (n : ℕ+) : (n : ℕ) ≠ 0 := ne_of_gt n.2

@[simp] theorem nat_coe_coe  {n : ℕ} : n > 0 → ((n : ℕ+) : ℕ) = n := succ_pred_eq_of_pos
@[simp] theorem to_pnat'_coe {n : ℕ} : n > 0 → (n.to_pnat' : ℕ) = n := succ_pred_eq_of_pos

instance : comm_monoid ℕ+ :=
{ mul       := λ m n, ⟨m.1 * n.1, mul_pos m.2 n.2⟩,
  mul_assoc := λ a b c, subtype.eq (mul_assoc _ _ _),
  one       := succ_pnat 0,
  one_mul   := λ a, subtype.eq (one_mul _),
  mul_one   := λ a, subtype.eq (mul_one _),
  mul_comm  := λ a b, subtype.eq (mul_comm _ _) }

@[simp] theorem one_coe : ((1 : ℕ+) : ℕ) = 1 := rfl

@[simp] theorem mul_coe (m n : ℕ+) : ((m * n : ℕ+) : ℕ) = m * n := rfl

@[simp] def pow (m : ℕ+) (n : ℕ) : ℕ+ :=
⟨nat.pow m n, nat.pos_pow_of_pos _ m.pos⟩

end pnat
