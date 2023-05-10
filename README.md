# FresnelEquations
The Fresnel equations describe how the fields of electromagnetic radiation (light) change upon reflecting or transmitting through an interface between two materials. This package defines 8 functions that describe the 8 different fresnel equations. This includes the refraction and transmission coefficients, and the reflectance and transmittance, for both s- and p- polarized light. The 8 functions are found in an overview in the table below, where the function subscripts indicate the polarization.

|Function|Description|Physical meaning|
|---|---|---|
|`R_s` and `R_p`|Reflectance|Fraction of energy reflected|
|`T_s` and `T_p`|Transmittance|Fraction of energy transmitted|
|`r_s` and `r_p`|Reflection coefficient|Change in amplitude of E-field upon reflection|
|`t_s` and `t_p`|Transmission coefficient|Change in amplitude of E-field upon transmission|