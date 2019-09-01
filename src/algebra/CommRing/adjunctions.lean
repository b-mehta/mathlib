/- Copyright (c) 2019 Scott Morrison. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Scott Morrison, Johannes Hölzl

Multivariable polynomials on a type is the left adjoint of the
forgetful functor from commutative rings to types.
-/

import algebra.CommRing.basic
import category_theory.adjunction.basic
import data.mv_polynomial

noncomputable theory

universe u

open mv_polynomial
open category_theory

namespace CommRing

local attribute [instance, priority 0] classical.prop_decidable

private def free_obj (α : Type u) : CommRing.{u} := ⟨mv_polynomial α ℤ⟩

def free : Type u ⥤ CommRing.{u} :=
{ obj := free_obj,
  map := λ _ _ f, rename_hom f,
  map_id' := λ X, rename_hom_id,
  map_comp' := λ X Y Z f g, rename_hom_comp f g }

@[simp] lemma free_obj_coe {α : Type u} :
  (free.obj α : Type u) = mv_polynomial α ℤ := rfl

@[simp] lemma free_map_coe {α β : Type u} {f : α → β} :
  ⇑(free.map f) = rename f := rfl

def adj : free ⊣ (forget CommRing) :=
adjunction.mk_of_hom_equiv
{ hom_equiv := λ X R, hom_equiv,
  hom_equiv_naturality_left_symm' := by {intros, ext, dsimp, apply eval₂_cast_comp} }

end CommRing
