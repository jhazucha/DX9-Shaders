uniform extern texture ColorTexture;
uniform extern texture StencilTexture;
uniform extern float Offset = 1.0 / 1024.0;

sampler2D ColorSampler = sampler_state
{
	Texture = (ColorTexture);
	MinFilter = LINEAR;
	MagFilter = LINEAR;
	MipFilter = LINEAR;
};

sampler2D StencilSampler = sampler_state
{
	Texture = (StencilTexture);
	MinFilter = LINEAR;
	MagFilter = LINEAR;
	MipFilter = LINEAR;
};

float GetEdge(float2 texCoord: TEXCOORD) : COLOR {
   // Sample neighbor pixels
   float s00 = tex2D(StencilSampler, texCoord + float2(-Offset, -Offset)).r;
   float s01 = tex2D(StencilSampler, texCoord + float2( 0,		-Offset)).r;
   float s02 = tex2D(StencilSampler, texCoord + float2( Offset, -Offset)).r;

   float s10 = tex2D(StencilSampler, texCoord + float2(-Offset,  0)).r;
   float s12 = tex2D(StencilSampler, texCoord + float2( Offset,  0)).r;

   float s20 = tex2D(StencilSampler, texCoord + float2(-Offset,  Offset)).r;
   float s21 = tex2D(StencilSampler, texCoord + float2( 0,	     Offset)).r;
   float s22 = tex2D(StencilSampler, texCoord + float2( Offset,  Offset)).r;
   
   float scale = 0.125;

   // Sobel filter in X direction
   float sobelX = s00 + scale * s10 + s20 - s02 - scale * s12 - s22;
   
   // Sobel filter in Y direction
   float sobelY = s00 + scale * s01 + s02 - s20 - scale * s21 - s22;

   // Find edge, skip sqrt() to improve performance ...
   float edgeSqr = sqrt(sobelX * sobelX + sobelY * sobelY);
   
   // ... and threshold against a squared value instead.
   return edgeSqr;// > 0.07 * 0.07;
   
   //return edgeSqr;
}

float4 StencilPS(float2 TexCoords : TEXCOORD0) : COLOR0
{
	float4 FinalColor;
	
	float2 samp = TexCoords;
	
	FinalColor = tex2D(ColorSampler, samp);
	FinalColor.a = tex2D(StencilSampler, samp).r;
	
	float Edge = GetEdge(TexCoords);
	
	if(Edge > 0.0) FinalColor = float4(0, 0, 0, Edge / 4);
	
	return FinalColor;
}

technique Stencil
{
    pass P0
    {
        PixelShader = compile ps_2_0 StencilPS();
    }
}