module FresnelEquations

# The equations are manually copied from https://en.wikipedia.org/wiki/Fresnel_equations
# Assumption: "As before, we are assuming the magnetic permeability, µ of both media to be equal to the permeability of free space µo as is essentially true of all dielectrics at optical frequencies."
#=

In one of the equations on the wiki page, they have replaced cos(θₜ)
with √(1-(n₁/n₂*sin(θᵢ))^2), stating that "The second form of each equation is derived from 
the first by eliminating θt using Snell's law and trigonometric identities. "

However, just applying Snell's law (θₜ = asin(n₁/n₂ * sin(θₜ))) and no trigonometric 
identities yields the same result, both in value and performance:

julia> let
           n1 = 1
           n2 = 2
           θᵢ = 0.2
           res1 = @btime √(1-(0.1/0.2*sin(0.5))^2)
           res2 = @btime cos(asin(0.1/0.2 * sin(0.5)))
           res1 == res2
       end
  1.450 ns (0 allocations: 0 bytes)
  1.411 ns (0 allocations: 0 bytes)
true

With this reasoning, the fourth argument to all 8 functions will 
be θₜ, and default to asin(n₁/n₂ * sin(θₜ))

=#

"""
Transmitted angle as function of n₁, n₂ and θᵢ.
By Snell's law, intended for internal use as 
default argument value for θₜ.
"""
_θₜ(n₁, n₂, θᵢ) = asin(n₁ / n₂ * sin(θᵢ))


"""
An internal function to check if the inputs make physical sense.
"""
function _check_angles(θᵢ, θₜ)
    if θᵢ > π / 2
        if θₜ > π / 2
            throw(ArgumentError("""
                Input angles θᵢ and θₜ and both greater than π/2. This is unphysical, and would have produced garbage results.
            """))
        end
        throw(ArgumentError("""
            Input angles θᵢ and θₜ and both greater than π/2. This is unphysical, and would have produced garbage results.
        """))
    elseif θₜ > π / 2
        throw(ArgumentError("""
            Input angle θₜ is greater than π/2. This is unphysical, and would have produced garbage results.
        """))
    end
    return nothing
end



"""
    R_s(n₁, n₂, θᵢ)
    R_s(n₁, n₂, θᵢ, θₜ)

Calculate the reflectance for s-polarized light, i.e. 
the fraction of incident light energy that is reflected. 

The transmitted angle θₜ defaults to `asin(n₁ / n₂ * sin(θᵢ))`, 
which Snell's law states.

# Arguments:
n₁: The refractive index of the original medium
n₂: The refractive index of the medium transmitted into
θᵢ: The incident angle in radians, meansured from the surface normal
θₜ: The transmitted angle in radians, measured  from the surface normal
"""
function R_s(n₁, n₂, θᵢ, θₜ=_θₜ(n₁, n₂, θᵢ))
    _check_angles(θᵢ, θₜ)
    num = n₁ * cos(θᵢ) - n₂ * cos(θₜ)
    den = n₁ * cos(θᵢ) + n₂ * cos(θₜ)
    return abs2(num / den)
end
export R_s

"""
    T_s(n₁, n₂, θᵢ)
    T_s(n₁, n₂, θᵢ, θₜ)

Calculate the transmittance for s-polarized light, i.e. 
the fraction of incident light energy that is transmitted. 

The transmitted angle θₜ defaults to `asin(n₁ / n₂ * sin(θᵢ))`, 
which Snell's law states.

# Arguments:
n₁: The refractive index of the original medium
n₂: The refractive index of the medium transmitted into
θᵢ: The incident angle in radians, meansured from the surface normal
θₜ: The transmitted angle in radians, measured  from the surface normal
"""
T_s(n₁, n₂, θᵢ, θₜ=_θₜ(n₁, n₂, θᵢ)) = 1 - R_s(n₁, n₂, θᵢ, θₜ)
export T_s

"""
    R_p(n₁, n₂, θᵢ)
    R_p(n₁, n₂, θᵢ, θₜ)

Calculate the reflectance for p-polarized light, i.e. 
the fraction of incident light energy that is reflected. 

The transmitted angle θₜ defaults to `asin(n₁ / n₂ * sin(θᵢ))`, 
which Snell's law states.

# Arguments:
n₁: The refractive index of the original medium
n₂: The refractive index of the medium transmitted into
θᵢ: The incident angle in radians, meansured from the surface normal
θₜ: The transmitted angle in radians, measured  from the surface normal
"""
function R_p(n₁, n₂, θᵢ, θₜ=_θₜ(n₁, n₂, θᵢ))
    _check_angles(θᵢ, θₜ)
    num = n₁ * cos(θₜ) - n₂ * cos(θᵢ)
    den = n₁ * cos(θₜ) + n₂ * cos(θᵢ)
    return abs2(num / den)
end
export R_p

"""
    T_p(n₁, n₂, θᵢ)
    T_p(n₁, n₂, θᵢ, θₜ)

Calculate the transmittance for p-polarized light, i.e. 
the fraction of incident light energy that is transmitted. 

The transmitted angle θₜ defaults to `asin(n₁ / n₂ * sin(θᵢ))`, 
which Snell's law states.

# Arguments:
n₁: The refractive index of the original medium
n₂: The refractive index of the medium transmitted into
θᵢ: The incident angle in radians, meansured from the surface normal
θₜ: The transmitted angle in radians, measured  from the surface normal
"""
T_p(n₁, n₂, θᵢ, θₜ=_θₜ(n₁, n₂, θᵢ)) = 1 - R_p(n₁, n₂, θᵢ, θₜ)
export T_p

# Complex amplitude reflection and transmission coefficients
# The equations consider a plane wave incident on a plane interface at angle of incidence θ i {\displaystyle \theta _{\mathrm {i} }}, a wave reflected at angle θ r = θ i {\displaystyle \theta _{\mathrm {r} }=\theta _{\mathrm {i} }}, and a wave transmitted at angle θ t {\displaystyle \theta _{\mathrm {t} }}.

"""
    r_s(n₁, n₂, θᵢ)
    r_s(n₁, n₂, θᵢ, θₜ)

Calculate the reflection coefficient for s-polarized light, i.e. 
the factor gained by the E-field amplitude by the reflection.

The transmitted angle θₜ defaults to `asin(n₁ / n₂ * sin(θᵢ))`, 
which Snell's law states.

# Arguments:
n₁: The refractive index of the original medium
n₂: The refractive index of the medium transmitted into
θᵢ: The incident angle in radians, meansured from the surface normal
θₜ: The transmitted angle in radians, measured  from the surface normal
"""
function r_s(n₁, n₂, θᵢ, θₜ=_θₜ(n₁, n₂, θᵢ))
    _check_angles(θᵢ, θₜ)
    num = n₁ * cos(θᵢ) - n₂ * cos(θₜ)
    den = n₁ * cos(θᵢ) + n₂ * cos(θₜ)
    return num / den
end
export r_s

"""
    t_s(n₁, n₂, θᵢ)
    t_s(n₁, n₂, θᵢ, θₜ)

Calculate the transmission coefficient for s-polarized light, i.e. 
the factor gained by the E-field amplitude by the transmission.

The transmitted angle θₜ defaults to `asin(n₁ / n₂ * sin(θᵢ))`, 
which Snell's law states.

# Arguments:
n₁: The refractive index of the original medium
n₂: The refractive index of the medium transmitted into
θᵢ: The incident angle in radians, meansured from the surface normal
θₜ: The transmitted angle in radians, measured  from the surface normal
"""
function t_s(n₁, n₂, θᵢ, θₜ=_θₜ(n₁, n₂, θᵢ))
    _check_angles(θᵢ, θₜ)
    num = 2n₁ * cos(θᵢ)
    den = n₁ * cos(θᵢ) + n₂ * cos(θₜ)
    return num / den
end
export t_s

"""
    r_p(n₁, n₂, θᵢ)
    r_p(n₁, n₂, θᵢ, θₜ)

Calculate the reflection coefficient for p-polarized light, i.e. 
the factor gained by the E-field amplitude by the reflection.

The transmitted angle θₜ defaults to `asin(n₁ / n₂ * sin(θᵢ))`, 
which Snell's law states.

# Arguments:
n₁: The refractive index of the original medium
n₂: The refractive index of the medium transmitted into
θᵢ: The incident angle in radians, meansured from the surface normal
θₜ: The transmitted angle in radians, measured  from the surface normal
"""
function r_p(n₁, n₂, θᵢ, θₜ=_θₜ(n₁, n₂, θᵢ))
    _check_angles(θᵢ, θₜ)
    num = n₂ * cos(θᵢ) - n₁ * cos(θₜ)
    den = n₂ * cos(θᵢ) + n₁ * cos(θₜ)
    return num / den
end
export r_p

"""
    t_p(n₁, n₂, θᵢ)
    t_p(n₁, n₂, θᵢ, θₜ)

Calculate the transmission coefficient for p-polarized light, i.e. 
the factor gained by the E-field amplitude by the transmission.

The transmitted angle θₜ defaults to `asin(n₁ / n₂ * sin(θᵢ))`, 
which Snell's law states.

# Arguments:
n₁: The refractive index of the original medium
n₂: The refractive index of the medium transmitted into
θᵢ: The incident angle in radians, meansured from the surface normal
θₜ: The transmitted angle in radians, measured  from the surface normal
"""
function t_p(n₁, n₂, θᵢ, θₜ=_θₜ(n₁, n₂, θᵢ))
    _check_angles(θᵢ, θₜ)
    num = 2n₁ * cos(θᵢ)
    den = n₂ * cos(θᵢ) + n₁ * cos(θₜ)
    return num / den
end
export t_p

end
