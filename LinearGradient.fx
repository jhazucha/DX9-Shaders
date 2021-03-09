uniform extern texture ColorTexture;
uniform extern float2 Position;
uniform extern float2 Size;
uniform extern float2 TargetSize;
uniform extern float4 Stop1 = float4(1.0, 1.0, 1.0, 1.0);
uniform extern float4 Stop2 = float4(0.8, 0.8, 0.8, 1.0);
uniform extern float4 Stop3 = float4(0.7, 0.7, 0.7, 1.0);

sampler2D ColorSampler = sampler_state
{
	Texture = (ColorTexture);
	MinFilter = LINEAR;
	MagFilter = LINEAR;
	MipFilter = LINEAR;
};

float4 LinearGradientPS(float2 TexCoords : TEXCOORD0) : COLOR0
{
	float diff = Size.y / TargetSize.y;
	float top = TexCoords.y - Position.y / TargetSize.y;
	float ty = top / diff;
	
	float4 FinalColor = Stop3;
	
	if(top < 0 || top > diff) 
		FinalColor = float4(0, 0, 0, 0);
	else
	{
		if(ty < 0.5)
		{
			FinalColor.r = lerp(Stop1.r, Stop2.r, ty);
			FinalColor.g = lerp(Stop1.g, Stop2.g, ty);
			FinalColor.b = lerp(Stop1.b, Stop2.b, ty);
		}
		
		FinalColor.a = tex2D(ColorSampler, TexCoords).a;
	}
	
	return FinalColor;
}

technique LinearGradient
{
    pass P0
    {
        PixelShader = compile ps_2_0 LinearGradientPS();
    }
}
