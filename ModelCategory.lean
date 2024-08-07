-- import LeanCopilot

import Mathlib.CategoryTheory.Square
import Mathlib.CategoryTheory.Limits.Shapes.Pullback.Square
import Mathlib.CategoryTheory.MorphismProperty.Factorization
import Mathlib.CategoryTheory.SmallObject.Construction

-----------------------------------------------------------------

-- example (a b c : Nat) : a + b + c = a + c + b := by
--   suggest_tactics "rw"

open CategoryTheory

#check MorphismProperty
#check MorphismProperty.MapFactorizationData
#check MorphismProperty.FactorizationData


section LiftingProperties

#check CommSq.HasLift
#check HasLiftingProperty
#check Square               -- import Mathlib.CategoryTheory.Square
#check Square.isPushout_iff -- import Mathlib.CategoryTheory.Limits.Shapes.Pullback.Square
#check IsPullback           -- import Mathlib.CategoryTheory.Limits.Shapes.Pullback.CommSq

section

variable {C : Type*} [Category C] {Z X Y P : C}
  {f : Z ⟶ X} {g : Z ⟶ Y} {inl : X ⟶ P} {inr : Y ⟶ P}

lemma pushout_desc_uniq (hP : IsPushout f g inl inr)
    {W : C} (h : X ⟶ W) (k : Y ⟶ W) (w : f ≫ h = g ≫ k)
    (d : P ⟶ W) (hl : inl ≫ d = h) (hr : inr ≫ d = k) : d = hP.desc h k w := by
  sorry
end

variable {C : Type*} [Category C] {A B A' B' X Y : C}
  (a : A ⟶ A') (i : A ⟶ B) (i' : A' ⟶ B') (b : B ⟶ B') (f : X ⟶ Y)

/--
```
  A ---a---> A' ---s--> X
  |          |          |
  i          i'         f
  |    p.o.  |          |
  v          v          v
  B ---b---> B' ---t--> Y

```
-/
lemma pushout_preserves_left_lifting_property
    (h : HasLiftingProperty i f) (po : IsPushout a i i' b) : HasLiftingProperty i' f :=
  ⟨fun {s} {t} sq => by
    have big_sq := CommSq.horiz_comp po.toCommSq sq
    have big_sq_hasLift := h.sq_hasLift big_sq
    have g := big_sq_hasLift.exists_lift.some
    let w := po.desc s g.l g.fac_left.symm
    let w_fac_left : i' ≫ w = s := po.inl_desc s g.l g.fac_left.symm
    -- have sq_A_A'_B_Y : CommSq a i (s ≫ f) (b ≫ t) := ⟨by simp only [← big_sq.w, Category.assoc]⟩
    have sq_lift : sq.LiftStruct := {
      l := w
      fac_left := w_fac_left
      fac_right := by
        -- have s : Limits.Cocone (Limits.span a i) := sq_A_A'_B_Y.cocone
        -- have := po.isColimit.uniq s
        --- pushout_desc_uniq
        have uniq := pushout_desc_uniq po (i' ≫ t) (b ≫ t) (by rw [po.w_assoc])
        have uniq_t := uniq t rfl rfl
        have uniq_w_f := uniq (w ≫ f) (by rw [← Category.assoc, w_fac_left, sq.w])
          (by rw [← Category.assoc, po.inr_desc s g.l g.fac_left.symm, g.fac_right])
        exact Eq.trans uniq_w_f uniq_t.symm
    }
    exact ⟨Nonempty.intro sq_lift⟩⟩

end LiftingProperties

-- small object argument
#check SmallObject.functor
