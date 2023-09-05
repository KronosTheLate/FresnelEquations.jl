# FresnelEquations
From the [wikipedia article on the Fresnel Equations](https://en.wikipedia.org/wiki/Fresnel_equations):
"The Fresnel equations (or Fresnel coefficients) describe the reflection and transmission of light (or electromagnetic radiation in general) when incident on an interface between different optical media."

This package defines 8 functions that implement the equations found in the wikipedia article. An overview of the functions is given below.

|Function|Description|Physical meaning|
|:---:|:---:|:---:|
|`R_s` and `R_p`|Reflectance|Fraction of energy reflected|
|`T_s` and `T_p`|Transmittance|Fraction of energy transmitted|
|`r_s` and `r_p`|Reflection coefficient|Change in amplitude of E-field upon reflection|
|`t_s` and `t_p`|Transmission coefficient|Change in amplitude of E-field upon transmission|

# Examples
Usage of this package is quite simple. Below is a demonstration of the usage of all 8 functions defined.
```
julia> using FresnelEquations

julia> let
           n1 = 1
           n2 = 2
           θ_i = deg2rad(10)
           [f(n1, n2, θ_i) for f in (R_s, R_p, T_s, T_p, r_s, r_p, t_s, t_p)]
       end
8-element Vector{Float64}:
  0.11454557997889622
  0.10771599997760896
  0.8854544200211036
  0.892284000022391
 -0.3384458301987132
  0.32820115779443704
  0.6615541698012867
  0.6641005788972185
```

Note that the transmittance `T` could be defined as `1 - R`, guaranteeing perfect energy conservation. This implementation can however suffer [catastrophic cancellation](https://en.wikipedia.org/wiki/Catastrophic_cancellation) as `R` approaches 1. Instead, the transmission coefficient `t` is used directly, meaning that conservation of energy is only accurate to numerical precision.
```
julia> let
           n1 = 1
           n2 = 2
           θ_i = deg2rad(10)
           @show R_s(n1, n2, θ_i) + T_s(n1, n2, θ_i)
           @show R_p(n1, n2, θ_i) + T_p(n1, n2, θ_i)
           nothing
       end
R_s(n1, n2, θ_i) + T_s(n1, n2, θ_i) = 0.9999999999999999
R_p(n1, n2, θ_i) + T_p(n1, n2, θ_i) = 1.0
```

# Assumptions
Note that some assumptions are made in deriving these equations:
1. The interface between the media is flat
2. The media are homogeneous and isotropic
3. The media are non-magnetic, i.e. with a [permeability](https://en.wikipedia.org/wiki/Permeability_(electromagnetism)) equal to that of vacuum.

You can read more about the assumptions and the sources referenced in the [wikipedia article on the Fresnel Equations](https://en.wikipedia.org/wiki/Fresnel_equations):
