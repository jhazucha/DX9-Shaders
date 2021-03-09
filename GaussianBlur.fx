uniform extern texture ColorTexture;
uniform extern float2 TargetSize = float2(800, 600);
uniform extern float GlowScalar = 1;

sampler2D ColorSampler = sampler_state
{
	Texture = (ColorTexture);
	MinFilter = LINEAR;
	MagFilter = LINEAR;
	MipFilter = LINEAR;
};

float4 BlurVertical(float2 TexCoords : TEXCOORD0) : COLOR0
{
	float2 samp = TexCoords;
	float4 FinalColor;

	float2 pixelSize = 1 / TargetSize;

	FinalColor = 0.5 * tex2D(ColorSampler, samp);

	samp.x = TexCoords.x;
	samp.y = TexCoords.y + pixelSize.y;

	FinalColor += 0.25 * tex2D(ColorSampler, samp);

	samp.x = TexCoords.x;
	samp.y = TexCoords.y - pixelSize.y;

	FinalColor += 0.25 * tex2D(ColorSampler, samp);

	return FinalColor;
}

float4 BlurHorizontal(float2 TexCoords : TEXCOORD0) : COLOR0
{
	float2 samp = TexCoords;
	float4 FinalColor;

	float2 pixelSize = 1 / TargetSize;

	FinalColor = 0.5 * tex2D(ColorSampler, samp);

	samp.x = TexCoords.x + pixelSize.x;
	samp.y = TexCoords.y;

	FinalColor += 0.25 * GlowScalar * tex2D(ColorSampler, samp);

	samp.x = TexCoords.x - pixelSize.x;
	samp.y = TexCoords.y;

	FinalColor += 0.25 * GlowScalar * tex2D(ColorSampler, samp);

	return FinalColor;
}

technique GaussianBlur
{
    pass P0
    {
        PixelShader = compile ps_2_0 BlurVertical();
    }
    pass P1
    {
        PixelShader = compile ps_2_0 BlurHorizontal();
    }
}