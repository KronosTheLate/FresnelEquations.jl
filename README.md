# FresnelEquations
From the [wikipedia article on the Fresnel Equations](https://en.wikipedia.org/wiki/Fresnel_equations):
"The Fresnel equations (or Fresnel coefficients) describe the reflection and transmission of light (or electromagnetic radiation in general) when incident on an interface between different optical media."

This package defines 8 functions that implement the equations found in the wikipedia article. An overview of the functions is given below.

|Function|Description|Physical meaning|
|:---:|:---:|:---:|
|`R_s` and `R_p`|Reflectance|Fraction of energy reflected|
|`T_s` and `T_p`|Transmittance|Fraction of energy transmitted|
|`r_s` and `r_p`|Reflection coefficient|Change in amplitude of E-field upon reflection (factor)|
|`t_s` and `t_p`|Transmission coefficient|Change in amplitude of E-field upon transmission (factor)|

## Quickstart
Usage of this package is quite simple. Below is a demonstration of the usage of all 8 functions defined.
```julia
julia> using FresnelEquations

julia> # Defining toy-input for functions

julia> n1 = 1; n2=2; angle_incident=deg2rad(45);

julia> # Looping over each of the 8 exported functions

julia> for func in (R_s, R_p, T_s, T_p, r_s, r_p, t_s, t_p)
           println(func, " = ", func(n1, n2, angle_incident))
       end
R_s = 0.20377661238703051
R_p = 0.04152490775593412
T_s = 0.7962233876129692
T_p = 0.9584750922440658
r_s = -0.4514162296451364
r_p = 0.20377661238703063
t_s = 0.5485837703548635
t_p = 0.6018883061935153
```

The functions have detailed docstrings, which are concidered the documentation of this package. 
Type `?` to enter the REPL help mode, and enter the name of the function to see the docstring. For example:
```julia
help?> R_s
search: R_s r_s @r_str @var_str @raw_str set_zero_subnormals get_zero_subnormals promote_shape PRESERVE_SEMVER current_task redirect_stdio redirect_stdin reenable_sigint redirect_stdout

  R_s(n₁, n₂, θᵢ)
  R_s(n₁, n₂, θᵢ, θₜ)

  Calculate the reflectance for s-polarized light, i.e. the fraction of incident light energy that is reflected.

  The transmitted angle θₜ defaults to asin(n₁ / n₂ * sin(θᵢ)), which Snell's law states.

  Arguments:
  ≡≡≡≡≡≡≡≡≡≡≡≡

  n₁: The refractive index of the original medium n₂: The refractive index of the medium transmitted into θᵢ: The incident angle in radians, meansured from the surface normal θₜ: The transmitted
  angle in radians, measured from the surface normal
```
This package uses unicode in docstrings and internals, but takes care to never force the user to use unicode for anything.

# Correctness conciderations
## Definition of transmittance
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

## Assumptions
Note that some assumptions are made in deriving these equations:
1. The interface between the media is flat
2. The media are homogeneous and isotropic
3. The media are non-magnetic, i.e. with a [permeability](https://en.wikipedia.org/wiki/Permeability_(electromagnetism)) equal to that of vacuum.

You can read more about the assumptions and the sources referenced in the [wikipedia article on the Fresnel Equations](https://en.wikipedia.org/wiki/Fresnel_equations):
