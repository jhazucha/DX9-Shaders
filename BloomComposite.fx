//*****************************************************************************
//	The final step in the bloom postprocessing effect; composites the base and blurred textures.
//*****************************************************************************
sampler BloomSampler : register( s0 );
sampler BaseSampler : register( s1 );

float BloomIntensity = 1.25f;
float BloomSaturation = 1.0f;

float BaseIntensity = 1.0f;
float BaseSaturation = 1.0f;

//*****************************************************************************
// Full Screen Quad Programs.
float4 AdjustSaturation(float4 color, float saturation)
{
	// The constants 0.3, 0.59, and 0.11 are chosen because the
	// human eye is more sensitive to green light, and less to blue.
	float grey = dot(color, float3(0.3, 0.59, 0.11));

	return lerp(grey, color, saturation);
}

float4 CompositePS(float2 texCoord : TEXCOORD0) : COLOR0
{
	// Look up the bloom and original base image colors.
	float4 bloom = tex2D(BloomSampler, texCoord);
	float4 base = tex2D(BaseSampler, texCoord);
    
	// Adjust color saturation and intensity.
	bloom = AdjustSaturation(bloom, BloomSaturation) * BloomIntensity;
	base = AdjustSaturation(base, BaseSaturation) * BaseIntensity;
    
	// Darken down the base image in areas where there is a lot of bloom,
	// to prevent things looking excessively burned-out.
	base *= (1 - saturate(bloom));
    
    // Combine the two images.
	return base + bloom;
}

//*****************************************************************************
technique BloomCompositeTech
{
	pass P0
	{
	    PixelShader = compile ps_2_0 CompositePS( );
	}
}